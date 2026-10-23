# frozen_string_literal: true

require "test_helper"

class Whose::ListComponentTest < ViewComponent::TestCase
  def test_list_renders_each_row
    render_inline(Whose::ListComponent.new) do |list|
      list.with_row(title: "Alice")
      list.with_row(title: "Bob")
    end

    assert_selector "li", count: 2
    assert_text "Alice"
    assert_text "Bob"
  end

  def test_list_passes_html_attributes_through
    render_inline(Whose::ListComponent.new(id: "x", data: { turbo_frame: "y" }, class: "extra"))

    assert_selector "ul#x.extra.divide-y[data-turbo-frame='y']"
  end
end
