# frozen_string_literal: true

require 'net/http'

namespace :heroku do
  desc 'Pings PING_URL to keep a dyno alive'
  # bundle exec rake heroku:dyno_ping
  task :dyno_ping do
    return if ENV['PING_URL'].blank?
    return unless working_day?
    return unless working_times?

    uri = URI(ENV['PING_URL'])
    Net::HTTP.get_response(uri)
  end

  private

  def working_day?
    working_days = %w[Monday Thursday Wednesday Thursday Friday]

    working_days.include?(Time.current.strftime('%A'))
  end

  def working_times?
    current_hour = Time.current.strftime('%H').to_i

    current_hour >= 10 && current_hour <= 18
  end
end
