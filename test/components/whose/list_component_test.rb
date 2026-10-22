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
end
