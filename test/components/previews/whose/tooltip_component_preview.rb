# frozen_string_literal: true

class Whose::TooltipComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def default
    tooltip_component(text: "Save the draft") do |tooltip|
      tag.button("Save", type: "button", aria: { describedby: tooltip.id }, class: "rounded-box border border-border bg-surface px-3 py-1.5 text-sm")
    end
  end

  def placements; end
end
