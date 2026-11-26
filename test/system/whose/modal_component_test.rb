# frozen_string_literal: true

require "application_system_test_case"

class Whose::ModalComponentSystemTest < ApplicationSystemTestCase
  def test_modal_opens_and_closes
    visit "/rails/view_components/whose/modal_component/default"

    click_button "Delete person"
    assert_selector "dialog[open]"

    find("dialog[open]").send_keys(:escape)
    assert_no_selector "dialog[open]", visible: :all

    click_button "Delete person"
    assert_selector "dialog[open]"

    page.driver.browser.mouse.click(x: 5, y: 5)
    assert_no_selector "dialog[open]", visible: :all
  end
end
