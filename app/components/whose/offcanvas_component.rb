# frozen_string_literal: true

class Whose::OffcanvasComponent < ViewComponent::Base
  SIDE_STYLES = {
    left: "mr-auto",
    right: "ml-auto"
  }.freeze

  renders_one :trigger

  def initialize(title:, side: :left, **html_attributes)
    @title = title
    @html_attributes = html_attributes
    @title_id = "whose-dialog-title-#{SecureRandom.hex(4)}"
    @side = side.to_sym
    raise ArgumentError, "Unknown side: #{side}. Use :left or :right." unless SIDE_STYLES.key?(@side)
  end

  def before_render
    raise ArgumentError, "The trigger slot is required." unless trigger?
  end

  def attributes
    @html_attributes.merge(data: { controller: "whose-dialog", action: "click->whose-dialog#backdropClose" }.merge(@html_attributes[:data] || {}))
  end

  def side_style
    SIDE_STYLES.fetch(@side)
  end
end
