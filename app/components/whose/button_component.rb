# frozen_string_literal: true

class Whose::ButtonComponent < ViewComponent::Base
  BASE_CLASSES = "inline-flex items-center justify-center gap-2 rounded-box font-sans font-medium " \
                 "cursor-pointer focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent " \
                 "disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none aria-disabled:opacity-50"
  VARIANT_CLASSES = {
    primary: "bg-accent text-on-accent hover:opacity-90",
    secondary: "bg-subtle text-fg border border-border hover:bg-border",
    danger: "bg-negative text-surface hover:opacity-90",
    invisible: "bg-transparent text-fg hover:bg-accent-soft hover:text-accent-text"
  }.freeze
  SIZE_CLASSES = {
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-base"
  }.freeze

  def initialize(variant: :primary, size: :md, href: nil, type: "button", disabled: false, **html_attributes)
    raise ArgumentError, "Unknown variant: #{variant.inspect}." unless VARIANT_CLASSES.key?(variant)
    raise ArgumentError, "Unknown size: #{size.inspect}." unless SIZE_CLASSES.key?(size)

    @variant = variant
    @size = size
    @href = href
    @type = type
    @disabled = disabled
    @html_attributes = html_attributes
  end

  def attributes
    @html_attributes.merge(class: [ BASE_CLASSES, VARIANT_CLASSES[@variant], SIZE_CLASSES[@size], @html_attributes[:class] ].compact)
  end
end
