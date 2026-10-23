# frozen_string_literal: true

class Whose::LinkComponent < ViewComponent::Base
  BASE_CLASSES = "rounded-box hover:underline " \
                 "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
  VARIANT_CLASSES = {
    accent: "text-accent-text",
    muted: "text-muted hover:text-fg"
  }.freeze

  def initialize(href:, variant: :accent, **html_attributes)
    @variant = variant.to_sym
    raise ArgumentError, "Unknown variant: #{variant.inspect}." unless VARIANT_CLASSES.key?(@variant)

    @href = href
    @html_attributes = html_attributes
  end

  def attributes
    @html_attributes.merge(class: [ BASE_CLASSES, VARIANT_CLASSES[@variant], @html_attributes[:class] ].compact)
  end
end
