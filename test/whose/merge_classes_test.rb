# frozen_string_literal: true

require "test_helper"

class Whose::MergeClassesTest < ActiveSupport::TestCase
  test "the last class for a property wins" do
    assert_equal "px-3 font-mono", Whose.merge_classes("font-sans px-3", "font-mono")
  end

  test "theme color names conflict as colors" do
    assert_equal "p-4 bg-accent", Whose.merge_classes("bg-surface p-4", "bg-accent")
  end

  test "the theme radius name conflicts with the tailwind radius scale" do
    assert_equal "rounded-lg", Whose.merge_classes("rounded-box", "rounded-lg")
  end

  test "nil and empty classes are ignored" do
    assert_equal "p-4", Whose.merge_classes(nil, "", "p-4", nil)
  end
end
