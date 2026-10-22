# frozen_string_literal: true

class Whose::PageHeaderComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def default
    page_header_component(title: "People", subtitle: "All members of the team") do |header|
      header.with_actions { "<button class='rounded-box bg-accent px-3 py-2 text-sm text-on-accent'>Add person</button>".html_safe }
    end
  end

  def title_only
    page_header_component(title: "People")
  end
end
