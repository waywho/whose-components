# frozen_string_literal: true

class Whose::CardComponent < ViewComponent::Base
  renders_one :header
  renders_one :footer

  BASE_CLASSES = "rounded-box border border-border bg-surface font-sans text-fg"

  def initialize(padded: true, **html_attributes)
    super()
    @padded = padded
    @html_attributes = html_attributes
  end

  def attributes
    @html_attributes.merge(
      class: [ BASE_CLASSES, @html_attributes[:class] ].compact,
      data: { card: true }.merge(@html_attributes[:data] || {})
    )
  end

  def body_classes
    "p-4" if @padded
  end
end
