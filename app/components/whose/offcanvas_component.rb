# frozen_string_literal: true

class Whose::OffcanvasComponent < ViewComponent::Base
  SIDE_STYLES = {
    left: "mr-auto",
    right: "ml-auto"
  }.freeze

  include Whose::Dialog

  def initialize(title:, side: :left, **html_attributes)
    @title = title
    @html_attributes = html_attributes
    @side = side.to_sym
    raise ArgumentError, "Unknown side: #{side}. Use :left or :right." unless SIDE_STYLES.key?(@side)
  end

  def side_style
    SIDE_STYLES.fetch(@side)
  end
end
