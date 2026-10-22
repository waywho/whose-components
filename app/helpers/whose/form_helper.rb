# frozen_string_literal: true

module Whose::FormHelper
  LAYOUTS = %i[vertical horizontal].freeze

  def whose_form_with(model: false, layout: :vertical, **options, &block)
    raise ArgumentError, "Unknown layout: #{layout.inspect}." unless LAYOUTS.include?(layout)

    form_with(model:, builder: Whose::Components::FormBuilder, layout:, **options, &block)
  end
end
