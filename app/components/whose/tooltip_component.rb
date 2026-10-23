# frozen_string_literal: true

# The gap uses margin, so a pointer that moves onto the tooltip hides it.
class Whose::TooltipComponent < ViewComponent::Base
  PLACEMENTS = {
    top: "bottom-full left-1/2 -translate-x-1/2 mb-2",
    bottom: "top-full left-1/2 -translate-x-1/2 mt-2",
    left: "right-full top-1/2 -translate-y-1/2 mr-2",
    right: "left-full top-1/2 -translate-y-1/2 ml-2"
  }.freeze

  attr_reader :text, :id, :placement_classes

  BASE_CLASSES = "group relative inline-flex w-fit"

  def initialize(text:, placement: :top, **html_attributes)
    @text = text
    @html_attributes = html_attributes
    @placement_classes = PLACEMENTS.fetch(placement) { raise ArgumentError, "Unknown placement: #{placement.inspect}" }
    @id = "tooltip-#{SecureRandom.hex(4)}"
  end

  def attributes
    @html_attributes.merge(class: [ BASE_CLASSES, @html_attributes[:class] ].compact)
  end
end
