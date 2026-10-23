# frozen_string_literal: true

require "test_helper"

class Whose::BadgeComponentTest < ViewComponent::TestCase
  def test_badge_renders_content
    render_inline(Whose::BadgeComponent.new(variant: :positive)) { "Active" }

    assert_selector "span", text: "Active"
  end

  def test_badge_passes_html_attributes_through
    render_inline(Whose::BadgeComponent.new(id: "x", data: { turbo_frame: "y" }, class: "extra")) { "Active" }

    assert_selector "span#x.extra.rounded-box[data-turbo-frame='y']"
  end

  def test_badge_accepts_string_variant
    render_inline(Whose::BadgeComponent.new(variant: "positive")) { "Active" }

    assert_selector "span.bg-positive-soft", text: "Active"
  end

  def test_badge_rejects_unknown_variant
    assert_raises(ArgumentError) { Whose::BadgeComponent.new(variant: :loud) }
  end
end
