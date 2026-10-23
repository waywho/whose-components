# frozen_string_literal: true

require "test_helper"

class Whose::PageHeaderComponentTest < ViewComponent::TestCase
  def test_page_header_renders_title_subtitle_and_actions
    render_inline(Whose::PageHeaderComponent.new(title: "People", subtitle: "All members")) do |header|
      header.with_actions { "Add" }
    end

    assert_selector "h1", text: "People"
    assert_text "All members"
    assert_selector "[data-slot=actions]", text: "Add"
  end

  def test_page_header_passes_html_attributes_through
    render_inline(Whose::PageHeaderComponent.new(title: "People", id: "x", data: { turbo_frame: "y" }, class: "extra"))

    assert_selector "header#x.extra.flex[data-turbo-frame='y']"
  end

  def test_page_header_omits_empty_subtitle_and_actions
    render_inline(Whose::PageHeaderComponent.new(title: "People"))

    assert_selector "h1", text: "People"
    assert_no_selector "[data-slot=actions]"
    assert_no_selector "p"
  end
end
