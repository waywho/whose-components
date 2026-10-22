# frozen_string_literal: true

class Whose::ListRowComponentPreview < ViewComponent::Preview
  def linked
    render(Whose::ListRowComponent.new(title: "Alice Smith", subtitle: "Admin", href: "#"))
  end

  def plain
    render(Whose::ListRowComponent.new(title: "Bob Jones"))
  end
end
