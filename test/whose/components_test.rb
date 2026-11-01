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

  test "engine keeps its Tailwind source out of the asset pipeline" do
    paths = Rails.application.config.assets.paths.map(&:to_s)

    refute_includes paths, Whose::Components::Engine.root.join("app/assets/tailwind").to_s
    assert_includes paths, Whose::Components::Engine.root.join("app/assets/fonts").to_s
  end
end
