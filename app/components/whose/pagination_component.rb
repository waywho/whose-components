# frozen_string_literal: true

class Whose::PaginationComponent < ViewComponent::Base
  def initialize(pagy:, **html_attributes)
    @pagy = pagy
    @html_attributes = html_attributes
  end

  def render?
    @pagy.last > 1
  end
end
