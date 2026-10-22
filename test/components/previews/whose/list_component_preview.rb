# frozen_string_literal: true

class Whose::ListComponentPreview < ViewComponent::Preview
  def default
    render(Whose::ListComponent.new) do |list|
      list.with_row(title: "Alice Smith", subtitle: "Admin", href: "#") do |row|
        row.with_leading { "<span class='inline-flex size-8 items-center justify-center rounded-full bg-accent-soft text-accent-text'>A</span>".html_safe }
        row.with_trailing { "Active" }
      end
      list.with_row(title: "Bob Jones", subtitle: "Member")
      list.with_row(title: "Carol White")
    end
  end
end
