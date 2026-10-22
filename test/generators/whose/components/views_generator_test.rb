# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/whose/components/views/views_generator"

class Whose::Components::Generators::ViewsGeneratorTest < Rails::Generators::TestCase
  tests Whose::Components::Generators::ViewsGenerator
  # Tests run in parallel processes, and a shared folder lets one process delete another's files.
  def destination_root = File.expand_path("../../../../tmp/generator/#{Process.pid}", __dir__)

  setup { prepare_destination }

  test "copies all auth views" do
    run_generator

    %w[sessions registrations confirmations passwords auth_mailer].each do |folder|
      gem_files = Dir.children(Whose::Components::Engine.root.join("app/views/whose", folder)).sort
      assert_not_empty gem_files
      assert_equal gem_files, Dir.children(File.join(destination_root, "app/views/whose", folder)).sort
    end
  end
end
