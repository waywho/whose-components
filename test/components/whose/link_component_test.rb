# frozen_string_literal: true

require "test_helper"

class Whose::LinkComponentTest < ViewComponent::TestCase
  def test_link_renders_anchor_with_href_and_content
    render_inline(Whose::LinkComponent.new(href: "/x")) { "Go" }

    assert_selector "a[href='/x']", text: "Go"
  end

  def test_accent_link_is_the_default
    render_inline(Whose::LinkComponent.new(href: "/x")) { "Go" }

    assert_selector "a.text-accent-text.hover\\:underline"
  end

  def test_muted_link_has_muted_text
    render_inline(Whose::LinkComponent.new(href: "/x", variant: :muted)) { "Go" }

    assert_selector "a.text-muted"
    assert_no_selector "a.text-accent-text"
  end

  def test_link_accepts_string_variant
    render_inline(Whose::LinkComponent.new(href: "/x", variant: "muted")) { "Go" }

    assert_selector "a.text-muted"
  end

  def test_link_has_a_focus_ring
    render_inline(Whose::LinkComponent.new(href: "/x")) { "Go" }

    assert_selector "a.rounded-box.focus-visible\\:outline-accent"
  end

  def test_link_rejects_unknown_variant
    assert_raises(ArgumentError) { Whose::LinkComponent.new(href: "/x", variant: :huge) }
  end

  def test_link_passes_html_attributes
    render_inline(Whose::LinkComponent.new(href: "/x", data: { turbo_method: :delete })) { "Go" }

    assert_selector "a[data-turbo-method=delete]"
  end

  def test_link_keeps_given_class_next_to_its_own
    render_inline(Whose::LinkComponent.new(href: "/x", class: "text-sm")) { "Go" }

    assert_selector "a.text-sm.text-accent-text"
  end
end
