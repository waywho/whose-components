# frozen_string_literal: true

require "test_helper"

class Whose::ButtonComponentTest < ViewComponent::TestCase
  def test_button_renders_link_when_href_given
    render_inline(Whose::ButtonComponent.new(href: "/x")) { "Go" }

    assert_selector "a[href='/x']", text: "Go"
    assert_no_selector "button"
  end

  def test_button_renders_button_with_type
    render_inline(Whose::ButtonComponent.new(type: "submit")) { "Save" }

    assert_selector "button[type=submit]", text: "Save"
  end

  def test_button_defaults_to_type_button
    render_inline(Whose::ButtonComponent.new) { "Save" }

    assert_selector "button[type=button]"
  end

  def test_button_passes_html_attributes
    render_inline(Whose::ButtonComponent.new(data: { turbo_method: :delete })) { "Delete" }

    assert_selector "button[data-turbo-method=delete]"
  end

  def test_button_keeps_given_class_next_to_its_own
    render_inline(Whose::ButtonComponent.new(class: "w-full")) { "Save" }

    assert_selector "button.w-full.bg-accent"
  end

  def test_button_rejects_unknown_variant
    assert_raises(ArgumentError) { Whose::ButtonComponent.new(variant: :huge) }
  end

  def test_button_rejects_unknown_size
    assert_raises(ArgumentError) { Whose::ButtonComponent.new(size: :xl) }
  end
end
