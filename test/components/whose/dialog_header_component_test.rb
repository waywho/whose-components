# frozen_string_literal: true

require "test_helper"

class Whose::DialogHeaderComponentTest < ViewComponent::TestCase
  def test_shows_the_title_with_its_id_and_a_close_button
    render_inline(Whose::DialogHeaderComponent.new(title: "Menu", title_id: "whose-dialog-title-1"))

    assert_selector "h2#whose-dialog-title-1", text: "Menu"
    assert_selector "button[type=button][data-action='whose-dialog#close'][aria-label=Close]"
  end
end
