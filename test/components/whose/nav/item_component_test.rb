# frozen_string_literal: true

require "test_helper"

class Whose::Nav::ItemComponentTest < ViewComponent::TestCase
  def test_item_active_on_nested_path
    request_path "/projects/3"

    render_inline(Whose::Nav::ItemComponent.new(label: "Projects", href: "/projects"))

    assert_selector "a[href='/projects'][aria-current=page]", text: "Projects"
  end

  def test_item_active_on_exact_path
    request_path "/projects"

    render_inline(Whose::Nav::ItemComponent.new(label: "Projects", href: "/projects"))

    assert_selector "a[aria-current=page]"
  end

  def test_item_not_active_on_path_with_same_prefix
    request_path "/projectsx"

    render_inline(Whose::Nav::ItemComponent.new(label: "Projects", href: "/projects"))

    assert_selector "a[href='/projects']"
    assert_no_selector "a[aria-current]"
  end

  def test_item_active_argument_overrides_path
    request_path "/projects"

    render_inline(Whose::Nav::ItemComponent.new(label: "Projects", href: "/projects", active: false))

    assert_no_selector "a[aria-current]"
  end

  def test_root_item_active_on_root_only
    request_path "/"
    render_inline(Whose::Nav::ItemComponent.new(label: "Home", href: "/"))
    assert_selector "a[aria-current=page]"

    request_path "/projects"
    render_inline(Whose::Nav::ItemComponent.new(label: "Home", href: "/"))
    assert_no_selector "a[aria-current]"
  end

  def test_item_renders_icon
    render_inline(Whose::Nav::ItemComponent.new(label: "Home", href: "/", icon: "<svg data-icon></svg>".html_safe))

    assert_selector "a svg[data-icon]"
  end

  private

  def request_path(path)
    vc_test_request.path_info = path
  end
end
