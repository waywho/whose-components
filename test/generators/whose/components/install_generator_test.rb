# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/whose/components/install/install_generator"

class Whose::Components::Generators::InstallGeneratorTest < Rails::Generators::TestCase
  tests Whose::Components::Generators::InstallGenerator
  destination File.expand_path("../../../../tmp/generator", __dir__)

  setup do
    prepare_destination
    write_destination_file "app/assets/tailwind/application.css", %(@import "tailwindcss";\n)
    write_destination_file "app/javascript/controllers/index.js", <<~JS
      import { application } from "controllers/application"
      import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
      eagerLoadControllersFrom("controllers", application)
    JS
  end

  test "adds engine css import" do
    run_generator

    assert_file "app/assets/tailwind/application.css",
                %(@import "tailwindcss";\n@import "../builds/tailwind/whose_components.css";\n)
  end

  test "registers whose stimulus controllers" do
    run_generator

    assert_file "app/javascript/controllers/index.js", /eagerLoadControllersFrom\("whose\/controllers", application\)/
  end

  test "is idempotent" do
    2.times { run_generator }

    assert_equal 1, File.read(File.join(destination_root, "app/assets/tailwind/application.css")).scan("whose_components.css").size
    assert_equal 1, File.read(File.join(destination_root, "app/javascript/controllers/index.js")).scan("whose/controllers").size
  end

  private

  def write_destination_file(path, content)
    full_path = File.join(destination_root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, content)
  end
end
