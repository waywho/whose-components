# frozen_string_literal: true

require "application_system_test_case"

class Whose::NavComponentSystemTest < ApplicationSystemTestCase
  def test_menu_button_opens_nav_on_small_screen
    page.driver.browser.manage.window.resize_to(375, 800)
    visit "/rails/view_components/whose/nav_component/horizontal"

    assert_no_selector "dialog a", visible: :visible
    find("button[aria-label='Open menu']").click
    assert_selector "dialog[open]"

    within("dialog[open]") { click_link "Vertical" }
    assert_current_path "/rails/view_components/whose/nav_component/vertical"
  end
end
