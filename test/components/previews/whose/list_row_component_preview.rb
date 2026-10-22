# frozen_string_literal: true

class Whose::ListRowComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  def linked
    list_row_component(title: "Alice Smith", subtitle: "Admin", href: "#")
  end

  def plain
    list_row_component(title: "Bob Jones")
  end
end
