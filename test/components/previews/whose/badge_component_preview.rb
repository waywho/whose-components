# frozen_string_literal: true

class Whose::BadgeComponentPreview < ViewComponent::Preview
  def neutral
    render(Whose::BadgeComponent.new(variant: :neutral)) { "Neutral" }
  end

  def accent
    render(Whose::BadgeComponent.new(variant: :accent)) { "Accent" }
  end

  def positive
    render(Whose::BadgeComponent.new(variant: :positive)) { "Active" }
  end

  def negative
    render(Whose::BadgeComponent.new(variant: :negative)) { "Failed" }
  end

  def warning
    render(Whose::BadgeComponent.new(variant: :warning)) { "Pending" }
  end
end
