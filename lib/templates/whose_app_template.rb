# Whose App Template
# Usage: rails new myapp -d postgresql -m path/to/whose_app_template.rb
#
# Rails 8 already provides: propshaft, puma, pg, bootsnap, importmap-rails,
# turbo-rails, stimulus-rails, web-console, capybara, debug, etc.

# ─── Frontend & Styling ─────────────────────────────────────────────────────

gem "tailwindcss-rails"
gem "flowbite", "~> 2.3"
gem "haml-rails", "~> 2.1.0"

# ─── Components ──────────────────────────────────────────────────────────────

gem "view_component"
gem "lookbook", "~> 2.3.4"
gem "nice_partials"
gem "whose-components", github: "waywho/whose-components"

# ─── Authentication ──────────────────────────────────────────────────────────

gem "devise"

# ─── Models & Data ───────────────────────────────────────────────────────────

gem "friendly_id"
gem "ranked-model"
gem "acts-as-taggable-on"
gem "nilify_blanks"

# ─── Storage & Images ───────────────────────────────────────────────────────

gem "image_processing", "~> 1.2"
gem "aws-sdk-s3", require: false

# ─── Development & Test ──────────────────────────────────────────────────────

gem_group :development, :test do
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
end

# ─── Development Only ────────────────────────────────────────────────────────

gem_group :development do
  gem "foreman"
  gem "letter_opener"
  gem "pry-remote"
  gem "listen"
  gem "dockerfile-rails", ">= 1.6"
end

# ─── Test Only ───────────────────────────────────────────────────────────────

gem_group :test do
  gem "cuprite"
end

# ─── Post-bundle setup ───────────────────────────────────────────────────────

after_bundle do
  # Tailwind CSS
  rails_command "tailwindcss:install"

  # Flowbite — pin in importmap and import in application.js
  append_to_file "config/importmap.rb",
    %(pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@4.0.1/dist/flowbite.turbo.min.js"\n)

  append_to_file "app/javascript/application.js", %(import 'flowbite';\n)

  # Flowbite — vendor JS for Tailwind @source scanning and datepicker
  directory_path = "vendor/javascript/flowbite"
  empty_directory directory_path
  run "curl -sL https://cdn.jsdelivr.net/npm/flowbite@4.0.1/dist/flowbite.turbo.min.js -o #{directory_path}/flowbite.turbo.min.js"
  run "curl -sL https://cdn.jsdelivr.net/npm/flowbite@4.0.1/plugin.js -o #{directory_path}/plugin.js"

  # Flowbite — add @source for Tailwind to scan flowbite classes
  inject_into_file "app/assets/tailwind/application.css", after: "@import \"tailwindcss\";\n" do
    <<~CSS

      @source "../../../vendor/javascript/flowbite/**/*.js";
    CSS
  end

  # Devise
  generate "devise:install"
  generate "devise", "User"

  # Friendly ID
  generate "friendly_id"

  # Acts As Taggable
  rails_command "acts_as_taggable_on_engine:install:migrations"

  # Whose Components
  generate "whose:components:install"

  # Database
  rails_command "db:create"
  rails_command "db:migrate"

  # Git
  git :init unless File.exist?(".git")
  git add: "."
  git commit: %(-m "Initial commit with Whose App Template")
end
