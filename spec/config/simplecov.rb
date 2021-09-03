# frozen_string_literal: true

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.command_name 'RSpec'
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter,
]
SimpleCov.start 'rails' do
  add_group 'Channels', 'app/channels'
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Libraries', 'lib'

  add_group 'Long files' do |src_file|
    src_file.lines.count > 1_000
  end

  add_filter '/config/'
  add_filter '/spec/'

  minimum_coverage 85
end

module SimpleCov
  module Formatter
    class RcovFormatter
      private

      def write_file(template, output_filename, binding)
        rcov_result = template.result(binding)

        File.open(output_filename, 'w') do |file_result|
          file_result.write rcov_result.force_encoding('UTF-8')
        end
      end
    end
  end
end
