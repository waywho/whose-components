# frozen_string_literal: true

require "test_helper"
require "rails/generators"
require "rails/generators/rails/app/app_generator"

class WhoseAppTemplateTest < ActiveSupport::TestCase
  TEMPLATE = File.expand_path("../../lib/templates/whose_app_template.rb", __dir__)

  setup { @tmp_dir = Dir.mktmpdir("whose-app-template-") }
  teardown { FileUtils.remove_entry(@tmp_dir) }

  test "writes the gems, settings and rules into a new app with sign-in" do
    generate_app("--auth")

    gemfile = app_file("Gemfile")
    assert_includes gemfile, %(gem "haml-rails")
    assert_includes gemfile, %(gem "view_component")
    assert_includes gemfile, %(gem "pagy", "~> 43")
    assert_includes gemfile, %(gem "whose-components", github: "waywho/whose-components")
    assert_match(/group :development, :test do.*gem "factory_bot_rails".*gem "faker"/m, gemfile)
    assert_match(/group :development do\n  gem "lookbook"\n  gem "letter_opener"/, gemfile)

    application = app_file("config/application.rb")
    assert_includes application, "g.template_engine :haml"
    assert_includes application, "g.helper false"
    assert_includes application, "g.jbuilder false"
    assert_includes application, "g.system_tests nil"
    assert_includes application, %(g.fixture_replacement :factory_bot, dir: "test/factories")

    assert_match(/^Style\/FrozenStringLiteralComment:\n  Enabled: true\n  EnforcedStyle: always$/, app_file(".rubocop.yml"))
    assert_match(/^  config\.generators\.apply_rubocop_autocorrect_after_generate!$/, app_file("config/environments/development.rb"))

    test_helper = app_file("test/test_helper.rb")
    assert_includes test_helper, "parallelize(workers: :number_of_processors)"
    assert_includes test_helper, "include FactoryBot::Syntax::Methods"
    assert_not_includes test_helper, "fixtures :all"

    assert_not File.exist?(File.join(app_path, "app/assets/stylesheets"))
    assert_path_exists File.join(app_path, "app/views/pwa/manifest.json.erb")

    assert_includes app_file("CLAUDE.md"), "# Demo"
    assert_path_exists File.join(app_path, ".claude/skills/asd-ste100/SKILL.md")
  end

  test "installs the gem from WHOSE_GEM_PATH and needs no prompt without sign-in" do
    generate_app("--no-auth", env: { "WHOSE_GEM_PATH" => "/src/whose-components" })

    assert_includes app_file("Gemfile"), %(gem "whose-components", path: "/src/whose-components")
  end

  test "reads the ref from each form of template URL" do
    base = "https://raw.githubusercontent.com/waywho/whose-components"
    path = "lib/templates/whose_app_template.rb"

    assert_equal "v0.1.0", template_ref("#{base}/v0.1.0/#{path}")
    assert_equal "main", template_ref("#{base}/refs/heads/main/#{path}")
    assert_equal "v0.1.0", template_ref("#{base}/refs/tags/v0.1.0/#{path}")
    assert_nil template_ref("/src/whose-components/#{path}")
  end

  test "names the commands to run by hand when bundling is skipped" do
    output = generate_app("--auth")

    assert_includes output, "bin/rails generate whose:components:install --auth"
    assert_includes output, "bin/rubocop -A"
    assert_includes output, "bin/rails db:create db:migrate"
  end

  test "leaves sign-in out with --no-auth" do
    output = generate_app("--no-auth")

    assert_includes output, "bin/rails generate whose:components:install, "
  end

  test "reads the root page from the --root flag" do
    assert_equal "pages#home", root_option(%w[new demo --root pages#home])
    assert_equal "landing#show", root_option(%w[new demo --root=landing#show])
    assert_nil root_option(%w[new demo])
    assert_raises(Thor::Error) { root_option(%w[new demo --root pages]) }
  end

  test "adds the root page that --root names, behind sign-in" do
    generate_app("--auth", "--root", "landing#show")

    assert_includes app_file("config/routes.rb"), %(root "landing#show")
    assert_match(/class LandingController < ApplicationController\n  def show; end\nend/, app_file("app/controllers/landing_controller.rb"))
    assert_path_exists File.join(app_path, "app/views/landing/show.html.haml")
    assert_includes app_file("test/controllers/landing_controller_test.rb"), "assert_redirected_to new_session_url"
  end

  test "adds a root page that renders without sign-in" do
    generate_app("--no-auth", "--root=pages#home")

    assert_includes app_file("config/routes.rb"), %(root "pages#home")
    assert_includes app_file("test/controllers/pages_controller_test.rb"), "assert_response :success"
  end

  test "adds no root page without --root" do
    generate_app("--no-auth")

    assert_not_includes app_file("config/routes.rb"), %(\n  root )
    assert_not File.exist?(File.join(app_path, "app/controllers/pages_controller.rb"))
  end

  private

  def template_ref(url)
    template_method(:whose_template_ref).whose_template_ref(url)
  end

  def root_option(args)
    template_method(:whose_root_option).whose_root_option(args)
  end

  def template_method(name)
    source = File.read(TEMPLATE)[/^def #{name}.*?^end$/m]
    Object.new.tap { it.instance_eval(source) }
  end

  def app_path
    File.join(@tmp_dir, "demo")
  end

  def app_file(path)
    File.read(File.join(app_path, path))
  end

  def generate_app(*flags, env: {})
    previous_env = ENV.to_h.slice("WHOSE_GEM_PATH")
    previous_argv = ARGV.dup
    previous_dir = Dir.pwd
    ENV.update(env)
    args = [ app_path, "-d", "postgresql", "--css", "tailwind", "--skip-bundle", "--skip-git", *flags, "-m", TEMPLATE ]
    ARGV.replace([ "new", *args ])
    capture_io { Rails::Generators::AppGenerator.start(args) }.first
  ensure
    Dir.chdir(previous_dir)
    ARGV.replace(previous_argv)
    env.each_key { ENV.delete(it) }
    ENV.update(previous_env)
  end
end
