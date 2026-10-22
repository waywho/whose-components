# frozen_string_literal: true

require "test_helper"

class Whose::CardComponentTest < ViewComponent::TestCase
  def test_card_renders_header_and_footer_slots
    render_inline(Whose::CardComponent.new) do |card|
      card.with_header { "Title" }
      card.with_footer { "Actions" }
      "Body"
    end

    assert_selector "[data-card] [data-card-header]", text: "Title"
    assert_selector "[data-card] [data-card-footer]", text: "Actions"
    assert_selector "[data-card]", text: "Body"
  end

  def test_card_body_has_no_padding_when_not_padded
    render_inline(Whose::CardComponent.new(padded: false)) { "Body" }

    assert_no_selector "[data-card] .p-4"
  end

  def test_card_passes_html_attributes_through
    render_inline(Whose::CardComponent.new(id: "x", data: { turbo_frame: "y" }, class: "extra")) { "Body" }

    assert_selector "div#x.extra.rounded-box[data-card][data-turbo-frame='y']"
  end

  def test_card_omits_header_and_footer_when_slots_empty
    render_inline(Whose::CardComponent.new) { "Body" }

    assert_selector "[data-card]", text: "Body"
    assert_no_selector "[data-card-header]"
    assert_no_selector "[data-card-footer]"
  end
end
