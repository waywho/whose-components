# frozen_string_literal: true

class Whose::FlashComponentPreview < ViewComponent::Preview
  def notice_and_alert
    render(Whose::FlashComponent.new(flash: { "notice" => "Saved.", "alert" => "Save failed. Try again." }))
  end

  def neutral
    render(Whose::FlashComponent.new(flash: { "info" => "A new version is ready." }))
  end
end
