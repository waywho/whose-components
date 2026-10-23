# frozen_string_literal: true

class Whose::DialogHeaderComponent < ViewComponent::Base
  def initialize(title:, title_id:)
    @title = title
    @title_id = title_id
  end
end
