# frozen_string_literal: true

class Whose::TooltipComponentPreview < ViewComponent::Preview
  def default
    render(Whose::TooltipComponent.new(text: "Save the draft")) do |tooltip|
      tag.button("Save", type: "button", aria: { describedby: tooltip.id }, class: "rounded-box border border-border bg-surface px-3 py-1.5 text-sm")
    end
  end

  def placements
    render_with_template
  end
end
