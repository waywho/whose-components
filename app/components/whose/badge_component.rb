# frozen_string_literal: true

class Whose::BadgeComponent < ViewComponent::Base
  BASE_CLASSES = "inline-flex items-center rounded-box px-2 py-0.5 font-sans text-xs font-medium"
  VARIANT_CLASSES = {
    neutral: "bg-canvas text-muted border border-border",
    accent: "bg-accent-soft text-accent-text",
    positive: "bg-positive-soft text-positive",
    negative: "bg-negative-soft text-negative",
    warning: "bg-warning-soft text-warning"
  }.freeze

  def initialize(variant: :neutral, **html_attributes)
    @variant = variant.to_sym
    raise ArgumentError, "Unknown variant: #{variant.inspect}." unless VARIANT_CLASSES.key?(@variant)

    @html_attributes = html_attributes
  end

  def attributes
    @html_attributes.merge(class: [ BASE_CLASSES, VARIANT_CLASSES[@variant], @html_attributes[:class] ].compact)
  end
end
