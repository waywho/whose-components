# frozen_string_literal: true

require "test_helper"

class Whose::ComponentHelperTest < ActionView::TestCase
  def test_slot_works_through_the_block
    html = Nokogiri::HTML5.fragment(card_component { it.with_header { "Title" } })

    assert_equal "Title", html.at_css("[data-card-header]").text
  end

  def test_every_public_component_has_a_helper
    component_files = Dir[Whose::Components::Engine.root.join("app/components/whose/**/*_component.rb")]
    class_names = component_files.map { |file| file.split("app/components/").last.delete_suffix(".rb").camelize }
    class_names -= [ "Whose::Form::FieldComponent" ]
    helper_names = class_names.map { |name| name.delete_prefix("Whose::").gsub("::", "").underscore }

    missing = helper_names.reject { Whose::ComponentHelper.method_defined?(it) }

    assert_empty missing
  end
end
