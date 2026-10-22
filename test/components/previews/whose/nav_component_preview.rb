# frozen_string_literal: true

class Whose::NavComponentPreview < ViewComponent::Preview
  PAGES = %i[horizontal vertical bottom].freeze

  def horizontal
    render_nav(:horizontal)
  end

  def vertical
    render_nav(:vertical)
  end

  def bottom
    render_nav(:bottom)
  end

  private

  def render_nav(orientation)
    render(Whose::NavComponent.new(orientation:)) do |nav|
      nav.with_brand { "Acme" }
      nav.with_actions { "Sign out" }
      PAGES.each do |page|
        nav.with_item(label: page.to_s.capitalize, href: "/rails/view_components/whose/nav_component/#{page}", active: page == orientation)
      end
    end
  end
end
