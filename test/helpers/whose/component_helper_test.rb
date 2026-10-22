# frozen_string_literal: true

require "test_helper"

class Whose::ComponentHelperTest < ActionView::TestCase
  include ViewComponent::TestHelpers
  include Pagy::Method

  def test_button_component
    assert_same_as_component(:button_component, Whose::ButtonComponent, variant: :secondary) { "Save" }
  end

  def test_link_component
    assert_same_as_component(:link_component, Whose::LinkComponent, href: "/projects") { "Projects" }
  end

  def test_badge_component
    assert_same_as_component(:badge_component, Whose::BadgeComponent, variant: :positive) { "New" }
  end

  def test_card_component
    assert_same_as_component(:card_component, Whose::CardComponent, padded: false) { "Body" }
  end

  def test_flash_component
    assert_same_as_component(:flash_component, Whose::FlashComponent, flash: { "notice" => "Saved." })
  end

  def test_page_header_component
    assert_same_as_component(:page_header_component, Whose::PageHeaderComponent, title: "Projects", subtitle: "All")
  end

  def test_list_component
    assert_same_as_component(:list_component, Whose::ListComponent) { "Rows" }
  end

  def test_list_row_component
    assert_same_as_component(:list_row_component, Whose::ListRowComponent, title: "Alpha", href: "/alpha")
  end

  def test_modal_component
    assert_same_as_component(:modal_component, Whose::ModalComponent, title: "Confirm") { |modal| modal.with_trigger { "Open" } }
  end

  def test_offcanvas_component
    assert_same_as_component(:offcanvas_component, Whose::OffcanvasComponent, title: "Menu", side: :right) { |offcanvas| offcanvas.with_trigger { "Open" } }
  end

  def test_tooltip_component
    assert_same_as_component(:tooltip_component, Whose::TooltipComponent, text: "Help", placement: :bottom) { "?" }
  end

  def test_nav_component
    assert_same_as_component(:nav_component, Whose::NavComponent, orientation: :bottom)
  end

  def test_nav_item_component
    assert_same_as_component(:nav_item_component, Whose::Nav::ItemComponent, label: "Projects", href: "/projects")
  end

  def test_pagination_component
    pagy = pagy(:offset, Array.new(95), page: 3, limit: 10,
                request: { base_url: "http://example.test", path: "/items", params: {} }).first

    assert_same_as_component(:pagination_component, Whose::PaginationComponent, pagy:)
  end

  def test_slot_works_through_the_block
    html = card_component { |card| card.with_header { "Title" } }

    assert_includes html, "Title"
  end

  def test_every_public_component_has_a_helper
    component_files = Dir[Whose::Components::Engine.root.join("app/components/whose/**/*_component.rb")]
    class_names = component_files.map { |file| file.split("app/components/").last.delete_suffix(".rb").camelize }
    class_names -= [ "Whose::Form::FieldComponent" ]
    helper_names = class_names.map { |name| name.delete_prefix("Whose::").gsub("::", "").underscore }

    missing = helper_names.reject { |name| Whose::ComponentHelper.method_defined?(name) }

    assert_empty missing
  end

  private

  def assert_same_as_component(helper_name, component_class, **arguments, &block)
    expected = vc_test_controller.view_context.render(component_class.new(**arguments), &block)

    assert_equal without_random_ids(expected), without_random_ids(send(helper_name, **arguments, &block))
  end

  def without_random_ids(html)
    html.gsub(/-\h{8}\b/, "-ID")
  end
end
