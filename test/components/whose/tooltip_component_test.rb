# frozen_string_literal: true

require "test_helper"

class Whose::TooltipComponentTest < ViewComponent::TestCase
  def test_tooltip_links_text_with_aria_describedby
    render_inline(Whose::TooltipComponent.new(text: "Save the draft")) do |tooltip|
      %(<button aria-describedby="#{tooltip.id}">Save</button>).html_safe
    end

    tooltip = page.find("[role=tooltip]")

    assert_equal "Save the draft", tooltip.text
    assert_predicate tooltip[:id], :present?
    assert_equal tooltip[:id], page.find("button")["aria-describedby"]
  end

  def test_wrapper_has_no_aria_describedby
    render_inline(Whose::TooltipComponent.new(text: "Help")) { "Save" }

    assert_no_selector "[aria-describedby]"
    assert_selector "span", text: "Save"
  end

  def test_tooltip_passes_html_attributes_through
    render_inline(Whose::TooltipComponent.new(text: "Help", id: "x", data: { turbo_frame: "y" }, class: "extra")) { "Save" }

    assert_selector "span#x.extra.group[data-turbo-frame='y']"
  end

  def test_each_tooltip_has_its_own_id
    first = render_inline(Whose::TooltipComponent.new(text: "One")).css("[role=tooltip]").first[:id]
    second = render_inline(Whose::TooltipComponent.new(text: "Two")).css("[role=tooltip]").first[:id]

    refute_equal first, second
  end

  def test_tooltip_id_has_the_whose_prefix
    render_inline(Whose::TooltipComponent.new(text: "Help")) { "Save" }

    assert_match(/\Awhose-tooltip-\h+\z/, page.find("[role=tooltip]", visible: :all)[:id])
  end

  def test_tooltip_shows_on_hover_and_focus_only
    render_inline(Whose::TooltipComponent.new(text: "Help")) { "Save" }

    assert_selector "[role=tooltip].invisible.group-hover\\:visible.group-focus-within\\:visible"
  end

  def test_placements_use_different_positions
    classes = %i[top bottom left right].to_h do |placement|
      [ placement, render_inline(Whose::TooltipComponent.new(text: "Help", placement:)).css("[role=tooltip]").first[:class] ]
    end

    assert_equal 4, classes.values.uniq.size
  end

  def test_unknown_placement_raises
    assert_raises(ArgumentError) { Whose::TooltipComponent.new(text: "Help", placement: :middle) }
  end
end
