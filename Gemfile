# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2'
# Use Puma as the app server
gem 'puma', '~> 5.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.2'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1'

# Use Active Storage variant
gem 'image_processing', '~> 1.12'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.5', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1'

# Autoload dotenv in Rails
gem 'dotenv-rails', '~> 2.7'

# Hashie is a collection of classes and mixins that make hashes more powerful.
gem 'hashie', '~> 4.1'

# A fast JSON:API serializer for Ruby Objects.
gem 'jsonapi-serializer', '~> 2.2'

# Makes http request
gem 'httparty', '~> 0.18'

# Paginator for Rails
gem 'kaminari', '~> 0.17'

# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.8'

# HTML Abstraction Markup Language - A Markup Haiku
gem 'haml', '~> 5.2'

# Ruby toolkit for the GitHub API
gem 'octokit', '~> 4.21'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1', platforms: %i[mri mingw x64_mingw]
  # Combine 'pry' with 'byebug'
  # Adds 'step', 'next', 'finish', 'continue' and 'break' commands to control execution
  gem 'pry-byebug', '~> 3.9'
  # Use Pry as your rails console
  gem 'pry-rails', '~> 0.3'
  # Pretty print Ruby objects to visualize their structure
  gem 'awesome_print', '~> 1.8', require: 'ap'

  # RuboCop is a Ruby code style checking and code formatting tool
  gem 'rubocop', '~> 1.5', require: false
  # Code style checking for RSpec files
  gem 'rubocop-rspec', '~> 2.0', require: false

  # Strategies for cleaning databases using ActiveRecord
  gem 'database_cleaner-active_record', '~> 1.8'
  # factory_bot_rails provides integration between factory_bot and rails 5.0 or newer
  gem 'factory_bot_rails', '~> 6.1'
  # Ffaker generates dummy data
  gem 'ffaker', '~> 2.17'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code
  gem 'web-console', '~> 4.1'
  # The Listen gem listens to file modifications and notifies you about the changes
  gem 'listen', '~> 3.3'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'

  # Brakeman detects security vulnerabilities in Ruby on Rails applications via static analysis
  gem 'brakeman', '~> 4.10'
  # This Rake task investigates the application's routes definition
  gem 'traceroute', '~> 0.8'
end

group :test do
  # The instafailing RSpec progress bar formatter
  gem 'fuubar', '~> 2.5'
  # rspec-rails is a testing framework for Rails 5+
  gem 'rspec-rails', '~> 4.0'
  # Shoulda Matchers provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 4.4'
  # Code coverage for Ruby with a powerful configuration library and automatic merging of coverage across test suites
  gem 'simplecov', '~> 0.20', require: false
  # Rcov style formatter for SimpleCov
  gem 'simplecov-rcov', '~> 0.2', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
