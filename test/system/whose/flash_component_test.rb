# frozen_string_literal: true

require "application_system_test_case"

class Whose::FlashComponentSystemTest < ApplicationSystemTestCase
  def test_alert_stays_until_closed_and_notice_hides
    visit "/rails/view_components/whose/flash_component/notice_and_alert"

    assert_selector "[role=alert]"
    assert_selector "[role=status]"
    assert_no_selector "[role=status]", wait: 7

    assert_selector "[role=alert]"

    find("[role=alert] button").click
    assert_no_selector "[role=alert]"
  end
end
