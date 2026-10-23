# frozen_string_literal: true

class Whose::FlashComponent < ViewComponent::Base
  STYLES = {
    "notice" => "bg-positive-soft text-positive border-positive",
    "alert" => "bg-negative-soft text-negative border-negative"
  }.freeze
  NEUTRAL_STYLE = "bg-surface text-fg border-border"
  AUTO_HIDE_DELAY = 5000

  BASE_CLASSES = "fixed top-4 right-4 z-50 flex w-full max-w-sm flex-col gap-2 px-4 sm:px-0"

  def initialize(flash:, **html_attributes)
    @messages = flash.to_h.transform_keys(&:to_s)
    @html_attributes = html_attributes
  end

  def render?
    @messages.any?
  end

  def attributes
    @html_attributes.merge(class: [ BASE_CLASSES, @html_attributes[:class] ].compact)
  end

  private

  def style_for(type)
    STYLES.fetch(type, NEUTRAL_STYLE)
  end

  def delay_for(type)
    type == "alert" ? 0 : AUTO_HIDE_DELAY
  end
end
