# frozen_string_literal: true

require "test_helper"
require "rails/generators"
require "rails/generators/rails/app/app_generator"

class WhoseAppTemplateTest < ActiveSupport::TestCase
  TEMPLATE = File.expand_path("../../lib/templates/whose_app_template.rb", __dir__)

  setup { @tmp_dir = Dir.mktmpdir("whose-app-template-") }
  teardown { FileUtils.remove_entry(@tmp_dir) }

  test "writes the gems, settings and rules into a new app with sign-in" do
    generate_app("WHOSE_AUTH" => "yes")

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

    assert_includes app_file("CLAUDE.md"), "# Demo"
    assert_path_exists File.join(app_path, ".claude/skills/asd-ste100/SKILL.md")
  end

  test "installs the gem from WHOSE_GEM_PATH and needs no prompt without sign-in" do
    generate_app("WHOSE_AUTH" => "no", "WHOSE_GEM_PATH" => "/src/whose-components")

    assert_includes app_file("Gemfile"), %(gem "whose-components", path: "/src/whose-components")
  end

  private

  def app_path
    File.join(@tmp_dir, "demo")
  end

  def app_file(path)
    File.read(File.join(app_path, path))
  end

  def generate_app(env)
    previous_env = ENV.to_h.slice("WHOSE_AUTH", "WHOSE_GEM_PATH")
    previous_dir = Dir.pwd
    ENV.update(env)
    Rails::Generators::AppGenerator.start([ app_path, "-d", "postgresql", "--css", "tailwind", "--skip-bundle", "--skip-git", "--quiet", "-m", TEMPLATE ])
  ensure
    Dir.chdir(previous_dir)
    env.each_key { ENV.delete(it) }
    ENV.update(previous_env)
  end
end
