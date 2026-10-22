# frozen_string_literal: true

class Whose::LinkComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def accent
    link_component(href: "/lookbook") { "Accent link" }
  end

  def muted
    link_component(href: "/lookbook", variant: :muted) { "Muted link" }
  end

  def in_paragraph
    render_with_template
  end
end
