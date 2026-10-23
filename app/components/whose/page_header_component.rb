# frozen_string_literal: true

class Whose::PageHeaderComponent < ViewComponent::Base
  renders_one :actions

  BASE_CLASSES = "flex w-full flex-wrap items-center justify-between gap-4 font-sans"

  def initialize(title:, subtitle: nil, **html_attributes)
    @title = title
    @subtitle = subtitle
    @html_attributes = html_attributes
  end

  def attributes
    @html_attributes.merge(class: [ BASE_CLASSES, @html_attributes[:class] ].compact)
  end
end
