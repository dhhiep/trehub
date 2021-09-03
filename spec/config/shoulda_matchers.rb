# frozen_string_literal: true

# Shoulda Matchers. For more details, see:
#   - https://github.com/thoughtbot/shoulda-matchers#rails-apps
#   - http://amalrik.github.io/2019/03/14/settingup-rails6-rspec/
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
