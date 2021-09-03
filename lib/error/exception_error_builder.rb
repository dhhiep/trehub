# frozen_string_literal: true

module Error
  module ExceptionErrorBuilder
    def error_builder(field, error_type, messages, option = {})
      error = {
        details: {
          "#{field}": [
            {
              error: error_type,
              value: option[:value]
            }
          ]
        },
        error: [messages].flatten.map { |message| "#{field.to_s.titleize} #{message}" }.join(', '),
        errors: {
          "#{field}": [messages].flatten
        }
      }

      error.to_json
    end
  end
end
