# frozen_string_literal: true

require "application_system_test_case"

class DocsHomeSystemTest < ApplicationSystemTestCase
  def test_home_page_opens_lookbook
    visit "/"

    click_link "Open Lookbook"

    assert_current_path "/lookbook"
    assert_text "Select a preview from the nav"
  end
end
