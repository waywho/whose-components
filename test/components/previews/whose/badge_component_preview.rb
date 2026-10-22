# frozen_string_literal: true

class Whose::BadgeComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def neutral
    badge_component(variant: :neutral) { "Neutral" }
  end

  def accent
    badge_component(variant: :accent) { "Accent" }
  end

  def positive
    badge_component(variant: :positive) { "Active" }
  end

  def negative
    badge_component(variant: :negative) { "Failed" }
  end

  def warning
    badge_component(variant: :warning) { "Pending" }
  end
end
