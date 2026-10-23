# frozen_string_literal: true

require "test_helper"

class Whose::OffcanvasComponentTest < ViewComponent::TestCase
  def render_offcanvas(**options)
    render_inline(Whose::OffcanvasComponent.new(title: "Menu", **options)) do |offcanvas|
      offcanvas.with_trigger { "<button type='button'>Open menu</button>".html_safe }
      "Panel body"
    end
  end

  def test_wrapper_holds_the_controller_and_backdrop_action
    render_offcanvas

    assert_selector "div[data-controller=whose-dialog][data-action='click->whose-dialog#backdropClose']"
  end

  def test_dialog_is_the_target_and_shows_title_and_body
    render_offcanvas

    assert_selector "dialog[data-whose-dialog-target=dialog]", visible: :all
    assert_selector "dialog h2", text: "Menu", visible: :all
    assert_selector "dialog", text: "Panel body", visible: :all
  end

  def test_trigger_opens_the_dialog
    render_offcanvas

    assert_selector "[data-action='click->whose-dialog#open']", text: "Open menu"
  end

  def test_dialog_is_named_by_the_title
    render_offcanvas

    title_id = page.find("dialog h2", visible: :all)[:id]
    assert_predicate title_id, :present?
    assert_selector "dialog[aria-labelledby='#{title_id}']", visible: :all
  end

  def test_offcanvas_passes_html_attributes_through
    render_offcanvas(id: "x", data: { turbo_frame: "y" }, class: "extra")

    assert_selector "div#x.extra[data-controller=whose-dialog][data-turbo-frame='y']"
  end

  def test_side_defaults_to_left
    render_offcanvas

    assert_selector "dialog[data-side=left]", visible: :all
  end

  def test_side_right
    render_offcanvas(side: :right)

    assert_selector "dialog[data-side=right]", visible: :all
  end

  def test_unknown_side_raises
    assert_raises(ArgumentError) { render_offcanvas(side: :top) }
  end
end
