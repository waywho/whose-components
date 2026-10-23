# frozen_string_literal: true

require "test_helper"

class Whose::NavComponentTest < ViewComponent::TestCase
  def test_nav_renders_brand_items_and_actions
    render_nav(:horizontal)

    assert_selector "nav [data-slot=brand]", text: "Acme"
    assert_selector "nav [data-slot=actions]", text: "Sign out"
    assert_selector "nav a[href='/projects']", text: "Projects", visible: :all
  end

  def test_horizontal_has_menu_button_and_offcanvas_with_same_items
    render_nav(:horizontal)

    assert_selector "button[aria-label='Open menu']"
    assert_selector "dialog a[href='/projects']", text: "Projects", visible: :all
  end

  def test_vertical_has_menu_button
    render_nav(:vertical)

    assert_selector "button[aria-label='Open menu']"
  end

  def test_bottom_has_no_menu_button_or_dialog
    render_nav(:bottom)

    assert_no_selector "button[aria-label='Open menu']"
    assert_no_selector "dialog", visible: :all
    assert_selector "nav a[href='/projects']", text: "Projects"
  end

  def test_bottom_renders_spacer_after_nav
    render_nav(:bottom)

    assert_selector "nav + [data-slot=spacer][aria-hidden=true]", visible: :all
  end

  def test_other_orientations_render_no_spacer
    render_nav(:horizontal)

    assert_no_selector "[data-slot=spacer]", visible: :all
  end

  def test_bottom_does_not_show_brand
    render_nav(:bottom)

    assert_no_selector "[data-slot=brand]"
  end

  def test_bottom_does_not_show_actions
    render_nav(:bottom)

    assert_no_selector "[data-slot=actions]", visible: :all
    assert_no_text "Sign out"
  end

  def test_nav_has_label
    render_nav(:bottom)

    assert_selector "nav[aria-label=Main]"
  end

  def test_nav_passes_html_attributes_through
    render_inline(Whose::NavComponent.new(id: "x", data: { turbo_permanent: true }, class: "extra"))

    assert_selector "nav#x.extra.flex[data-turbo-permanent][aria-label=Main]"
  end

  def test_unknown_orientation_raises
    assert_raises(ArgumentError) { Whose::NavComponent.new(orientation: :diagonal) }
  end

  private

  def render_nav(orientation)
    render_inline(Whose::NavComponent.new(orientation:)) do |nav|
      nav.with_brand { "Acme" }
      nav.with_actions { "Sign out" }
      nav.with_item(label: "Projects", href: "/projects")
    end
  end
end
