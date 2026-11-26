# frozen_string_literal: true

require "test_helper"
require "capybara/cuprite"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, screen_size: [ 1400, 900 ], options: { process_timeout: 30 }
end
