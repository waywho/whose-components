# frozen_string_literal: true

class Whose::ListRowComponent < ViewComponent::Base
  renders_one :leading
  renders_one :trailing

  BASE_CLASSES = "flex items-center gap-3 px-4 py-3 font-sans"

  def initialize(title:, subtitle: nil, href: nil, **html_attributes)
    super()
    @title = title
    @subtitle = subtitle
    @href = href
    @html_attributes = html_attributes
  end

  def attributes
    @html_attributes.merge(class: [ BASE_CLASSES, @html_attributes[:class] ].compact)
  end
end
