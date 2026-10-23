# frozen_string_literal: true

require "test_helper"

class Whose::PaginationComponentTest < ViewComponent::TestCase
  include Pagy::Method

  def test_renders_nothing_for_one_page
    render_inline(Whose::PaginationComponent.new(pagy: build_pagy(count: 5)))

    assert_no_selector "nav"
  end

  def test_marks_current_page
    render_inline(Whose::PaginationComponent.new(pagy: build_pagy(count: 95, page: 3)))

    assert_selector "nav.pagy.series-nav a[aria-current=page]", text: "3"
  end

  def test_passes_html_attributes_through
    render_inline(Whose::PaginationComponent.new(pagy: build_pagy(count: 95), id: "x", data: { turbo_frame: "y" }, class: "extra"))

    assert_selector "div#x.extra[data-turbo-frame='y'] nav.pagy"
  end

  private

  def build_pagy(count:, page: 1)
    pagy(:offset, Array.new(count), page:, limit: 10,
         request: { base_url: "http://example.test", path: "/items", params: {} }).first
  end
end
