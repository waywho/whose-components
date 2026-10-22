# frozen_string_literal: true

class Whose::ButtonComponentPreview < ViewComponent::Preview
  def primary
    render(Whose::ButtonComponent.new(variant: :primary)) { "Primary" }
  end

  def secondary
    render(Whose::ButtonComponent.new(variant: :secondary)) { "Secondary" }
  end

  def danger
    render(Whose::ButtonComponent.new(variant: :danger)) { "Delete" }
  end

  def invisible
    render(Whose::ButtonComponent.new(variant: :invisible)) { "Invisible" }
  end

  def small
    render(Whose::ButtonComponent.new(size: :sm)) { "Small" }
  end

  def link
    render(Whose::ButtonComponent.new(href: "/lookbook")) { "Link" }
  end
end
