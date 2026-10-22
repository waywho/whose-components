# frozen_string_literal: true

class Whose::FlashComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def notice_and_alert
    flash_component(flash: { "notice" => "Saved.", "alert" => "Save failed. Try again." })
  end

  def neutral
    flash_component(flash: { "info" => "A new version is ready." })
  end
end
