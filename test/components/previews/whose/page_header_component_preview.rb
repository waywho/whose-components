# frozen_string_literal: true

class Whose::PageHeaderComponentPreview < ViewComponent::Preview
  def default
    render(Whose::PageHeaderComponent.new(title: "People", subtitle: "All members of the team")) do |header|
      header.with_actions { "<button class='rounded-box bg-accent px-3 py-2 text-sm text-on-accent'>Add person</button>".html_safe }
    end
  end

  def title_only
    render(Whose::PageHeaderComponent.new(title: "People"))
  end
end
