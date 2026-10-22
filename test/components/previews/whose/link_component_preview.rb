# frozen_string_literal: true

class Whose::LinkComponentPreview < ViewComponent::Preview
  def accent
    render(Whose::LinkComponent.new(href: "/lookbook")) { "Accent link" }
  end

  def muted
    render(Whose::LinkComponent.new(href: "/lookbook", variant: :muted)) { "Muted link" }
  end

  def in_paragraph
    render_with_template
  end
end
