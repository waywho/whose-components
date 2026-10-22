# frozen_string_literal: true

module Whose::FormHelper
  LAYOUTS = %i[vertical horizontal inline].freeze
  ROW_CLASSES = "flex flex-col gap-4 sm:flex-row sm:items-start"

  def whose_form_with(model: false, layout: :vertical, **options, &block)
    raise ArgumentError, "Unknown layout: #{layout.inspect}." unless LAYOUTS.include?(layout)

    form_with(model:, builder: Whose::Components::FormBuilder, layout:, **options) do |form|
      layout == :inline ? tag.div(capture(form, &block), class: ROW_CLASSES, data: { form_row: true }) : capture(form, &block)
    end
  end
end
