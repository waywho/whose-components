# frozen_string_literal: true

require "test_helper"
require "open3"

class InstallRailsrcTest < ActiveSupport::TestCase
  SCRIPT = File.expand_path("../../bin/install-railsrc", __dir__)
  TEMPLATE_URL = "https://raw.githubusercontent.com/waywho/whose-components/v#{Whose::Components::VERSION}/lib/templates/whose_app_template.rb"

  setup { @home = Dir.mktmpdir("whose-home-") }
  teardown { FileUtils.remove_entry(@home) }

  test "writes the defaults and the template URL of this version" do
    _output, status = run_script

    assert status.success?
    assert_equal "-d postgresql\n--css tailwind\n-m #{TEMPLATE_URL}\n", railsrc
  end

  test "replaces an older whose-components railsrc" do
    File.write(railsrc_path, "-d postgresql\n-m https://raw.githubusercontent.com/waywho/whose-components/v0.0.1/lib/templates/whose_app_template.rb\n")

    _output, status = run_script

    assert status.success?
    assert_includes railsrc, TEMPLATE_URL
  end

  test "keeps a railsrc of another kind unless --force" do
    File.write(railsrc_path, "--skip-test\n")

    output, status = run_script

    assert_not status.success?
    assert_includes output, "--force"
    assert_equal "--skip-test\n", railsrc

    _output, status = run_script("--force")

    assert status.success?
    assert_includes railsrc, TEMPLATE_URL
  end

  private

  def railsrc_path
    File.join(@home, ".railsrc")
  end

  def railsrc
    File.read(railsrc_path)
  end

  def run_script(*args)
    Open3.capture2e({ "HOME" => @home }, RbConfig.ruby, SCRIPT, *args)
  end
end
