# frozen_string_literal: true

class Whose::ListComponent < ViewComponent::Base
  renders_many :rows, Whose::ListRowComponent
end
