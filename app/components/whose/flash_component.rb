# frozen_string_literal: true

class Whose::FlashComponent < ViewComponent::Base
  STYLES = {
    "notice" => "bg-positive-soft text-positive border-positive",
    "alert" => "bg-negative-soft text-negative border-negative"
  }.freeze
  NEUTRAL_STYLE = "bg-surface text-fg border-border"
  AUTO_HIDE_DELAY = 5000

  def initialize(flash:)
    @messages = flash.to_h.transform_keys(&:to_s)
  end

  def render?
    @messages.any?
  end

  def style_for(type)
    STYLES.fetch(type, NEUTRAL_STYLE)
  end

  def delay_for(type)
    type == "alert" ? 0 : AUTO_HIDE_DELAY
  end
end
