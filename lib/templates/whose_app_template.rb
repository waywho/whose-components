# frozen_string_literal: true

require "shellwords"
require "tmpdir"

def whose_template_ref(url)
  url[%r{waywho/whose-components/(?:refs/(?:heads|tags)/)?([^/]+)/lib/templates/}, 1]
end

# rails new keeps flags it does not know in ARGV and leaves them out of options.
def whose_flag_value(args, name)
  args.each_cons(2).find { |flag, _| flag == "--#{name}" }&.last ||
    args.find { it.start_with?("--#{name}=") }&.delete_prefix("--#{name}=")
end

def whose_root_option(args)
  value = whose_flag_value(args, "root")
  return unless value
  raise Thor::Error, "Use --root controller#action, for example --root pages#home." unless value.match?(/\A[a-z_]+#[a-z_]+\z/)

  value
end

template_ref = whose_template_ref(__FILE__)
root_page = whose_root_option(ARGV)
gem_path = whose_flag_value(ARGV, "component-gem-path")

if __FILE__.match?(%r{\Ahttps?://})
  gem_checkout = Dir.mktmpdir("whose-components-")
  at_exit { FileUtils.remove_entry(gem_checkout) }
  git clone: [ "--quiet", "--depth=1", *("--branch=#{template_ref}" if template_ref), "https://github.com/waywho/whose-components.git", gem_checkout ].shelljoin
  source_paths.unshift(File.join(gem_checkout, "lib/templates/app"))
else
  source_paths.unshift(File.join(__dir__, "app"))
end

auth = ARGV.include?("--auth") || (!ARGV.include?("--no-auth") && yes?("Add sign-in? (y/n)"))

gem "haml-rails"
gem "view_component"
gem "pagy", "~> 43"
if gem_path
  gem "whose-components", path: gem_path
elsif template_ref
  gem "whose-components", github: "waywho/whose-components", ref: template_ref
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

remove_dir "app/assets/stylesheets"

gsub_file "test/test_helper.rb", /^ *# Setup all fixtures.*\n *fixtures :all\n/, "    include FactoryBot::Syntax::Methods\n"

template "CLAUDE.md.tt", "CLAUDE.md"
directory ".claude", ".claude"

route %(mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?)

if root_page
  controller, action = root_page.split("#")
  route %(root "#{root_page}")
  create_file "app/controllers/#{controller}_controller.rb", <<~RUBY
    # frozen_string_literal: true

    class #{controller.camelize}Controller < ApplicationController
      def #{action}; end
    end
  RUBY
  create_file "app/views/#{controller}/#{action}.html.haml", %(= page_header_component(title: "#{action.humanize}")\n)
  create_file "test/controllers/#{controller}_controller_test.rb", <<~RUBY
    # frozen_string_literal: true

    require "test_helper"

    class #{controller.camelize}ControllerTest < ActionDispatch::IntegrationTest
      #{auth ? %(test "#{action} asks a signed-out visitor to sign in" do) : %(test "#{action} renders" do)}
        get root_url

        #{auth ? "assert_redirected_to new_session_url" : "assert_response :success"}
      end
    end
  RUBY
end

github_steps = <<~TEXT
  To put the app on GitHub:
  1. Make an empty repository at https://github.com/new.
  2. Run: git remote add origin git@github.com:<your-account>/#{app_name}.git
  3. Run: git push -u origin main
TEXT

after_bundle do
  if options[:skip_bundle]
    say "Bundling was skipped. Run these commands in the app: bundle install, " \
        "bin/rails generate whose:components:install#{" --auth" if auth}, bin/rubocop -A, " \
        'bin/rails db:create db:migrate, git init, git add . and git commit -m "Initial commit".'
    say github_steps
    next
  end

  generate "whose:components:install", *("--auth" if auth)
  run "bin/rubocop -A"
  rails_command "db:create"
  rails_command "db:migrate"
  if options[:skip_git]
    say "Git was skipped, so the template made no commit."
    next
  end

  git add: "."
  git commit: %(-m "Initial commit")
  say github_steps
end
