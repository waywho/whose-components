# frozen_string_literal: true

require "test_helper"

class Whose::ListRowComponentTest < ViewComponent::TestCase
  def test_list_row_links_when_href_given
    render_inline(Whose::ListRowComponent.new(title: "Alice", href: "/people/1"))

    assert_selector "a[href='/people/1']", text: "Alice"
  end

  def test_list_row_does_not_link_without_href
    render_inline(Whose::ListRowComponent.new(title: "Alice", subtitle: "Admin"))

    assert_no_selector "a"
    assert_text "Alice"
    assert_text "Admin"
  end

  def test_list_row_passes_html_attributes_through
    render_inline(Whose::ListRowComponent.new(title: "Alice", id: "x", data: { turbo_frame: "y" }, class: "extra"))

    assert_selector "li#x.extra.flex[data-turbo-frame='y']"
  end

  def test_list_row_renders_leading_and_trailing_slots
    render_inline(Whose::ListRowComponent.new(title: "Alice")) do |row|
      row.with_leading { "L" }
      row.with_trailing { "T" }
    end

    assert_selector "[data-slot=leading]", text: "L"
    assert_selector "[data-slot=trailing]", text: "T"
  end
end
