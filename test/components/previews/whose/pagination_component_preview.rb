# frozen_string_literal: true

class Whose::PaginationComponentPreview < ViewComponent::Preview
  include Pagy::Method

  def first_page
    render(Whose::PaginationComponent.new(pagy: build_pagy(page: 1)))
  end

  def middle_page
    render(Whose::PaginationComponent.new(pagy: build_pagy(page: 5)))
  end

  def last_page
    render(Whose::PaginationComponent.new(pagy: build_pagy(page: 10)))
  end

  private

  def build_pagy(page:)
    pagy(:offset, Array.new(95), page:, limit: 10,
         request: { base_url: "http://localhost", path: "/", params: {} }).first
  end
end
