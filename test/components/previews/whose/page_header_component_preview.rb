# frozen_string_literal: true

class Whose::PageHeaderComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def default
    render_with_template
  end

  def title_only
    page_header_component(title: "People")
  end
end
