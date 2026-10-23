# frozen_string_literal: true

require "test_helper"

class Whose::FlashComponentTest < ViewComponent::TestCase
  def test_flash_renders_nothing_when_empty
    refute Whose::FlashComponent.new(flash: {}).render?
  end

  def test_flash_escapes_message
    render_inline(Whose::FlashComponent.new(flash: { "notice" => "<b>x</b>" }))

    assert_selector "[role=status]", text: "<b>x</b>"
    assert_no_selector "[role=status] b"
  end

  def test_flash_maps_alert_to_the_alert_role_and_other_types_to_the_status_role
    render_inline(Whose::FlashComponent.new(flash: { "notice" => "Saved.", "alert" => "Failed.", "other" => "Note." }))

    assert_selector "[role=status]", text: "Saved."
    assert_selector "[role=alert]", text: "Failed."
    assert_selector "[role=status]", text: "Note."
  end

  def test_alert_never_hides_by_itself_and_notice_hides_after_5000_ms
    render_inline(Whose::FlashComponent.new(flash: { "notice" => "Saved.", "alert" => "Failed." }))

    assert_selector "[role=status][data-whose-notification-delay-value='5000']", text: "Saved."
    assert_selector "[role=alert][data-whose-notification-delay-value='0']", text: "Failed."
  end

  def test_every_message_has_a_close_button
    render_inline(Whose::FlashComponent.new(flash: { "notice" => "Saved." }))

    assert_selector "[role=status] button[aria-label=Close][data-action~='whose-notification#hide']"
  end

  def test_close_button_has_a_focus_ring
    render_inline(Whose::FlashComponent.new(flash: { "notice" => "Saved." }))

    assert_selector "button[aria-label=Close].focus-visible\\:outline-2.focus-visible\\:outline-accent"
  end

  def test_flash_passes_html_attributes_through
    render_inline(Whose::FlashComponent.new(flash: { "notice" => "Saved." }, id: "x", data: { turbo_permanent: true }, class: "extra"))

    assert_selector "div#x.extra.fixed[data-turbo-permanent]"
  end
end
