# frozen_string_literal: true

class Whose::PageHeaderComponent < ViewComponent::Base
  renders_one :actions

  def initialize(title:, subtitle: nil)
    @title = title
    @subtitle = subtitle
  end
end
