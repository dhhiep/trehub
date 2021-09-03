# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    include Error::ExceptionErrorBuilder

    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Error::GatewayError, with: :gateway_error

    before_action :authorized

    def authorized
      return if request.headers['Api-key'] == ENV['API_KEY']

      render json: error_builder(:Apikey, :invalid, 'Unauthorized'), status: :unauthorized
    end

    def not_found
      render json: error_builder(:record, :invalid, 'Not Found'), status: :not_found
    end

    def request_includes
      if params[:include]&.blank?
        []
      elsif params[:include].present?
        params[:include].split(',')
      end
    end

    def resource_includes
      (request_includes || default_resource_includes).map(&:intern)
    end

    # https://jsonapi.org/format/#fetching-includes
    def default_resource_includes
      []
    end

    def serialize_resource(resource)
      resource_serializer.new(
        resource,
        include: resource_includes,
        fields: sparse_fields
      ).serializable_hash
    end

    def sparse_fields
      return unless params[:fields]&.respond_to?(:each)

      fields = {}
      params[:fields]
        .select { |_, v| v.is_a?(String) }
        .each { |type, values| fields[type.intern] = values.split(',').map(&:intern) }
      fields.presence
    end

    def gateway_error(exception)
      render_error_payload(exception.message)
    end

    def render_error_payload(error, status = 422)
      if error.is_a?(Struct)
        render json: { error: error.to_s, errors: error.to_h }, status: status, content_type: content_type
      elsif error.is_a?(String)
        render json: error, status: status, content_type: content_type
      end
    end
  end
end
