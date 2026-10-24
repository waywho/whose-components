# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "puma"
gem "sqlite3"
gem "propshaft"
gem "lookbook", "~> 2.3"
gem "pagy", "~> 43.0"

group :development, :test do
  gem "factory_bot_rails"
  gem "capybara"
  gem "selenium-webdriver"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "letter_opener"
end

gem "bump", "~> 0.10.0", group: :development
