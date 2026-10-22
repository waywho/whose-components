# frozen_string_literal: true

require "test_helper"

class DocsHomeTest < ActionDispatch::IntegrationTest
  test "home page opens without sign in" do
    get root_path

    assert_response :success
  end
end
