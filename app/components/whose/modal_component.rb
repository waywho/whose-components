# frozen_string_literal: true

class Whose::ModalComponent < ViewComponent::Base
  renders_one :trigger
  renders_one :footer

  def initialize(title:, **html_attributes)
    @title = title
    @title_id = "whose-dialog-title-#{SecureRandom.hex(4)}"
    @html_attributes = html_attributes
  end

  def attributes
    @html_attributes.merge(data: { controller: "whose-dialog", action: "click->whose-dialog#backdropClose" }.merge(@html_attributes[:data] || {}))
  end

  def before_render
    raise ArgumentError, "The trigger slot is required." unless trigger?
  end
end
