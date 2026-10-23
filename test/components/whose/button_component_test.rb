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
    render_inline(Whose::ButtonComponent.new(class: "mt-4")) { "Save" }

    assert_selector "button.mt-4.bg-accent"
  end

  def test_button_is_as_wide_as_its_content_by_default
    render_inline(Whose::ButtonComponent.new) { "Save" }

    assert_selector "button.w-fit"
    assert_no_selector "button.w-full"
  end

  def test_full_button_fills_its_container
    render_inline(Whose::ButtonComponent.new(full: true)) { "Save" }

    assert_selector "button.w-full"
    assert_no_selector "button.w-fit"
  end

  def test_secondary_button_has_a_subtle_background
    render_inline(Whose::ButtonComponent.new(variant: :secondary)) { "Back" }

    assert_selector "button.bg-subtle", text: "Back"
  end

  def test_button_accepts_string_variant_and_size
    render_inline(Whose::ButtonComponent.new(variant: "secondary", size: "sm")) { "Back" }

    assert_selector "button.bg-subtle.text-sm", text: "Back"
  end

  def test_invisible_button_has_no_background
    render_inline(Whose::ButtonComponent.new(variant: :invisible)) { "Cancel" }

    assert_selector "button.bg-transparent", text: "Cancel"
  end

  def test_disabled_button_has_disabled_attribute
    render_inline(Whose::ButtonComponent.new(disabled: true)) { "Save" }

    assert_selector "button[disabled]", text: "Save"
  end

  def test_enabled_button_has_no_disabled_attribute
    render_inline(Whose::ButtonComponent.new) { "Save" }

    assert_no_selector "button[disabled]"
  end

  def test_disabled_link_has_no_href_and_is_aria_disabled
    render_inline(Whose::ButtonComponent.new(href: "/x", disabled: true)) { "Go" }

    assert_selector "a[aria-disabled=true]", text: "Go"
    assert_no_selector "a[href]"
  end

  def test_enabled_link_is_not_aria_disabled
    render_inline(Whose::ButtonComponent.new(href: "/x")) { "Go" }

    assert_no_selector "a[aria-disabled]"
  end

  def test_button_rejects_unknown_variant
    assert_raises(ArgumentError) { Whose::ButtonComponent.new(variant: :huge) }
  end

  def test_button_rejects_unknown_size
    assert_raises(ArgumentError) { Whose::ButtonComponent.new(size: :xl) }
  end
end
