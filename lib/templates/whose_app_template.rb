# frozen_string_literal: true

require "shellwords"
require "tmpdir"

if __FILE__.match?(%r{\Ahttps?://})
  gem_checkout = Dir.mktmpdir("whose-components-")
  at_exit { FileUtils.remove_entry(gem_checkout) }
  git clone: [ "--quiet", "--depth=1", "https://github.com/waywho/whose-components.git", gem_checkout ].shelljoin
  source_paths.unshift(File.join(gem_checkout, "lib/templates/app"))
else
  source_paths.unshift(File.join(__dir__, "app"))
end

auth = ENV["WHOSE_AUTH"] ? ENV["WHOSE_AUTH"].match?(/\A(y|yes|true|1)\z/i) : yes?("Add sign-in? (y/n)")

gem "haml-rails"
gem "view_component"
gem "pagy", "~> 43"
if ENV["WHOSE_GEM_PATH"]
  gem "whose-components", path: ENV["WHOSE_GEM_PATH"]
else
  gem "whose-components", github: "waywho/whose-components"
end

gem_group :development, :test do
  gem "factory_bot_rails"
  gem "faker"
end

gem_group :development do
  gem "lookbook"
  gem "letter_opener"
end

environment <<~RUBY
  config.generators do |g|
    g.template_engine :haml
    g.helper false
    g.jbuilder false
    g.system_tests nil
    g.fixture_replacement :factory_bot, dir: "test/factories"
  end

RUBY

append_to_file ".rubocop.yml", <<~YAML

  Style/FrozenStringLiteralComment:
    Enabled: true
    EnforcedStyle: always
YAML

uncomment_lines "config/environments/development.rb", /config\.generators\.apply_rubocop_autocorrect_after_generate!/
environment "config.action_mailer.delivery_method = :letter_opener", env: "development"

gsub_file "test/test_helper.rb", /^ *# Setup all fixtures.*\n *fixtures :all\n/, "    include FactoryBot::Syntax::Methods\n"

template "CLAUDE.md.tt", "CLAUDE.md"
directory ".claude", ".claude"

route %(mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?)

after_bundle do
  next if options[:skip_bundle]

  generate "whose:components:install", *("--auth" if auth)
  run "bin/rubocop -A"
  rails_command "db:create"
  rails_command "db:migrate"
  git add: "."
  git commit: %(-m "Initial app from the whose-components template")
end
