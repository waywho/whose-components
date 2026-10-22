# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "puma"
gem "sqlite3"
gem "propshaft"

group :development, :test do
  gem "lookbook", "~> 2.3"
  gem "factory_bot_rails"
  gem "capybara"
  gem "selenium-webdriver"
  gem "rubocop-rails-omakase", require: false
  gem "pagy", "~> 43.0"
end

group :development do
  gem "letter_opener"
end
