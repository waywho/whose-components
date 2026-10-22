# frozen_string_literal: true

class Whose::OffcanvasComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  BUTTON_CLASS = "cursor-pointer rounded-box bg-accent px-3 py-2 text-sm text-on-accent"

  def left
    offcanvas_component(title: "Menu") do |offcanvas|
      offcanvas.with_trigger { "<button type='button' class='#{BUTTON_CLASS}'>Open panel</button>".html_safe }
      "Panel content."
    end
  end

  def right
    offcanvas_component(title: "Menu", side: :right) do |offcanvas|
      offcanvas.with_trigger { "<button type='button' class='#{BUTTON_CLASS}'>Open panel</button>".html_safe }
      "Panel content."
    end
  end
end
