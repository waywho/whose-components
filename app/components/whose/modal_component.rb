# frozen_string_literal: true

class Whose::ModalComponent < ViewComponent::Base
  renders_one :trigger
  renders_one :footer

  def initialize(title:)
    @title = title
    @title_id = "whose-dialog-title-#{SecureRandom.hex(4)}"
  end

  def before_render
    raise ArgumentError, "The trigger slot is required." unless trigger?
  end
end
