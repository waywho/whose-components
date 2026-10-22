# frozen_string_literal: true

class Whose::CardComponentPreview < ViewComponent::Preview
  def default
    render(Whose::CardComponent.new) { "Card body" }
  end

  def with_header_and_footer
    render(Whose::CardComponent.new) do |card|
      card.with_header { "Header" }
      card.with_footer { "Footer" }
      "Card body"
    end
  end

  def unpadded
    render(Whose::CardComponent.new(padded: false)) { "Card body" }
  end
end
