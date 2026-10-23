# frozen_string_literal: true

class Whose::ModalComponent < ViewComponent::Base
  include Whose::Dialog

  renders_one :footer

  def initialize(title:, **html_attributes)
    @title = title
    @html_attributes = html_attributes
  end
end
