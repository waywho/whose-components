# frozen_string_literal: true

class Whose::CardComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def default
    card_component { "Card body" }
  end

  def with_header_and_footer
    card_component do |card|
      card.with_header { "Header" }
      card.with_footer { "Footer" }
      "Card body"
    end
  end

  def unpadded
    card_component(padded: false) { "Card body" }
  end
end
