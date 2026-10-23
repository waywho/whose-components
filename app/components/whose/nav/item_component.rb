# frozen_string_literal: true

class Whose::Nav::ItemComponent < ViewComponent::Base
  def initialize(label:, href:, icon: nil, active: nil, **html_attributes)
    @label = label
    @href = href
    @icon = icon
    @active = active
    @html_attributes = html_attributes
  end

  def active?
    return @active unless @active.nil?

    current_page?(@href) || request.path.start_with?("#{@href}/")
  end

  def link_style
    active? ? "bg-accent-soft text-accent-text" : "text-muted hover:text-fg"
  end
end
