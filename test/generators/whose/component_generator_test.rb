# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
Rails::Generators.configure!(Whose::Components::Engine.config.generators)
require "generators/whose/component/component_generator"

class Whose::ComponentGeneratorTest < Rails::Generators::TestCase
  tests Whose::ComponentGenerator
  # Tests run in parallel processes, and a shared folder lets one process delete another's files.
  def destination_root = File.expand_path("../../../tmp/generator/#{Process.pid}", __dir__)

  setup do
    prepare_destination
    write_destination_file "app/helpers/whose/component_helper.rb", <<~RUBY
      module Whose::ComponentHelper
        def button_component(*, **, &) = render(Whose::ButtonComponent.new(*, **), &)
      end
    RUBY
  end

  test "adds the whose namespace to the component" do
    run_generator %w[Message]

    assert_file "app/components/whose/message_component.rb", /class Whose::MessageComponent < ViewComponent::Base/
    assert_file "app/components/whose/message_component/message_component.html.haml"
    assert_file "test/components/whose/message_component_test.rb"
    assert_file "test/components/previews/whose/message_component_preview.rb"
    assert_no_file "app/components/whose/message_component/message_component_controller.js"
  end

  test "does not add the namespace twice" do
    run_generator %w[Whose::Message]

    assert_file "app/components/whose/message_component.rb"
    assert_no_directory "app/components/whose/whose"
  end

  test "adds a helper for the component" do
    run_generator %w[Chat::Message]

    assert_file "app/helpers/whose/component_helper.rb" do |helper|
      assert_match "  def button_component(*, **, &) = render(Whose::ButtonComponent.new(*, **), &)\n" \
                   "  def chat_message_component(*, **, &) = render(Whose::Chat::MessageComponent.new(*, **), &)\nend\n", helper
    end
  end

  test "passes view component flags on" do
    run_generator %w[Message --locale --skip-preview]

    assert_file "app/components/whose/message_component/message_component.yml"
    assert_no_file "test/components/previews/whose/message_component_preview.rb"
  end

  test "writes a call method and no template with the call option" do
    run_generator %w[Message --call]

    assert_file "app/components/whose/message_component.rb", /def call/
    assert_no_file "app/components/whose/message_component/message_component.html.haml"
  end

  test "writes an inline haml template with the inline option" do
    run_generator %w[Message --inline]

    assert_file "app/components/whose/message_component.rb", /haml_template <<~HAML/
    assert_no_file "app/components/whose/message_component/message_component.html.haml"
  end

  test "adds a whose stimulus controller with the stimulus option" do
    run_generator %w[Composer --stimulus]

    assert_file "app/javascript/whose/controllers/whose_composer_controller.js", /export default class extends Controller/
    assert_no_file "app/components/whose/composer_component/composer_component_controller.js"
    assert_no_file "app/javascript/controllers/whose/composer_controller.js"
  end

  private

  def write_destination_file(path, content)
    full_path = File.join(destination_root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, content)
  end
end
