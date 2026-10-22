# frozen_string_literal: true

# ponytail: no repositioning at the screen edge. Add a Stimulus controller when a tooltip gets clipped.
# The gap uses margin, so a pointer that moves onto the tooltip hides it.
class Whose::TooltipComponent < ViewComponent::Base
  PLACEMENTS = {
    top: "bottom-full left-1/2 -translate-x-1/2 mb-2",
    bottom: "top-full left-1/2 -translate-x-1/2 mt-2",
    left: "right-full top-1/2 -translate-y-1/2 mr-2",
    right: "left-full top-1/2 -translate-y-1/2 ml-2"
  }.freeze

  attr_reader :text, :id, :placement_classes

  def initialize(text:, placement: :top)
    @text = text
    @placement_classes = PLACEMENTS.fetch(placement) { raise ArgumentError, "Unknown placement: #{placement.inspect}" }
    @id = "tooltip-#{SecureRandom.hex(4)}"
  end
end
