# frozen_string_literal: true

require "application_system_test_case"

class Whose::FlashComponentSystemTest < ApplicationSystemTestCase
  def test_alert_stays_until_closed_and_notice_hides
    visit "/rails/view_components/whose/flash_component/notice_and_alert"

    assert_selector "[data-flash-type=alert]"
    assert_selector "[data-flash-type=notice]"
    assert_no_selector "[data-flash-type=notice]", wait: 8

    sleep 1
    assert_selector "[data-flash-type=alert]"

    find("[data-flash-type=alert] button").click
    assert_no_selector "[data-flash-type=alert]"
  end
end
