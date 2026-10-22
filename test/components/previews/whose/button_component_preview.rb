# frozen_string_literal: true

class Whose::ButtonComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def primary
    button_component(variant: :primary) { "Primary" }
  end

  def secondary
    button_component(variant: :secondary) { "Secondary" }
  end

  def danger
    button_component(variant: :danger) { "Delete" }
  end

  def invisible
    button_component(variant: :invisible) { "Invisible" }
  end

  def full
    button_component(full: true) { "Full width" }
  end

  def small
    button_component(size: :sm) { "Small" }
  end

  def link
    button_component(href: "/lookbook") { "Link" }
  end

  def disabled
    button_component(disabled: true) { "Disabled" }
  end

  def disabled_link
    button_component(href: "/lookbook", disabled: true) { "Disabled link" }
  end
end
