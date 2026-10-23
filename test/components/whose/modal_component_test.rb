# frozen_string_literal: true

require "test_helper"

class Whose::ModalComponentTest < ViewComponent::TestCase
  def render_modal(**options)
    render_inline(Whose::ModalComponent.new(title: "Delete person", **options)) do |modal|
      modal.with_trigger { "<button type='button'>Open</button>".html_safe }
      modal.with_footer { "Footer text" }
      "Body text"
    end
  end

  def test_wrapper_holds_the_controller_and_backdrop_action
    render_modal

    assert_selector "div[data-controller=whose-dialog][data-action='click->whose-dialog#backdropClose']"
  end

  def test_dialog_is_the_target_and_shows_title_body_and_footer
    render_modal

    assert_selector "dialog[data-whose-dialog-target=dialog]", visible: :all
    assert_selector "dialog h2", text: "Delete person", visible: :all
    assert_selector "dialog", text: "Body text", visible: :all
    assert_selector "dialog", text: "Footer text", visible: :all
  end

  def test_trigger_opens_the_dialog
    render_modal

    assert_selector "[data-action='click->whose-dialog#open']", text: "Open"
  end

  def test_trigger_slot_is_required
    assert_raises(ArgumentError) do
      render_inline(Whose::ModalComponent.new(title: "Delete person")) { "Body" }
    end
  end

  def test_close_button_has_the_close_action_and_aria_label
    render_modal

    assert_selector "dialog button[data-action='whose-dialog#close'][aria-label=Close]", visible: :all
  end

  def test_dialog_is_named_by_the_title
    render_modal

    title_id = page.find("dialog h2", visible: :all)[:id]
    assert_predicate title_id, :present?
    assert_selector "dialog[aria-labelledby='#{title_id}']", visible: :all
  end

  def test_modal_passes_html_attributes_through
    render_modal(id: "x", data: { turbo_frame: "y" }, class: "extra")

    assert_selector "div#x.extra[data-controller=whose-dialog][data-turbo-frame='y']"
  end

  def test_title_ids_are_unique_per_instance
    first = render_modal.css("h2").first["id"]
    second = render_modal.css("h2").first["id"]

    refute_equal first, second
  end
end
