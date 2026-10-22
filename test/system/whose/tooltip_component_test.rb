# frozen_string_literal: true

require "application_system_test_case"

class Whose::TooltipComponentSystemTest < ApplicationSystemTestCase
  def test_tooltip_shows_above_the_middle_of_its_button
    visit "/rails/view_components/whose/tooltip_component/default"

    button = find_button("Save")
    button.hover
    tooltip = find("[role=tooltip]", text: "Save the draft")

    button_box = button.evaluate_script("this.getBoundingClientRect().toJSON()")
    tooltip_box = tooltip.evaluate_script("this.getBoundingClientRect().toJSON()")
    button_middle = button_box["left"] + (button_box["width"] / 2)
    tooltip_middle = tooltip_box["left"] + (tooltip_box["width"] / 2)

    assert_in_delta button_middle, tooltip_middle, 1
    assert_operator tooltip_box["bottom"], :<=, button_box["top"]
  end
end
