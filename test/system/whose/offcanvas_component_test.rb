# frozen_string_literal: true

require "application_system_test_case"

class Whose::OffcanvasComponentSystemTest < ApplicationSystemTestCase
  def test_offcanvas_opens_on_its_side_and_closes
    visit "/rails/view_components/whose/offcanvas_component/right"

    click_button "Open panel"
    assert_selector "dialog[open][data-side=right]"

    find("dialog[open] button[aria-label=Close]").click
    assert_no_selector "dialog[open]", visible: :all
  end
end
