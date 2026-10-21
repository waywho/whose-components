# frozen_string_literal: true

require "test_helper"

class Whose::ComponentsTest < ActiveSupport::TestCase
  test "engine loads" do
    assert_equal "0.1.0", Whose::Components::VERSION
    assert_operator Whose::Components::Engine, :<, Rails::Engine
    assert_equal "whose_components", Whose::Components::Engine.engine_name
  end

  test "engine pins the vendored Stimulus packages" do
    assert_includes Rails.application.importmap.packages, "@stimulus-components/dialog"
  end
end
