# frozen_string_literal: true

class Whose::ListComponent < ViewComponent::Base
  renders_many :rows, Whose::ListRowComponent

  BASE_CLASSES = "w-full divide-y divide-border overflow-hidden rounded-box border border-border bg-surface font-sans"

  def initialize(**html_attributes)
    @html_attributes = html_attributes
  end

  def attributes
    @html_attributes.merge(class: [ BASE_CLASSES, @html_attributes[:class] ].compact)
  end
end
