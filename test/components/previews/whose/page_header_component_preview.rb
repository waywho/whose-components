# frozen_string_literal: true

class Whose::PageHeaderComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def default
  end

  def title_only
    page_header_component(title: "People")
  end
end
