# frozen_string_literal: true

class Whose::ModalComponentPreview < ViewComponent::Preview
  include Whose::ComponentHelper

  BUTTON_CLASS = "cursor-pointer rounded-box bg-accent px-3 py-2 text-sm text-on-accent"

  def default
    modal_component(title: "Delete person") do |modal|
      modal.with_trigger { "<button type='button' class='#{BUTTON_CLASS}'>Delete person</button>".html_safe }
      modal.with_footer { "<button type='button' data-action='whose-dialog#close' class='#{BUTTON_CLASS}'>Cancel</button>".html_safe }
      "This action cannot be undone."
    end
  end

  def without_footer
    modal_component(title: "About") do |modal|
      modal.with_trigger { "<button type='button' class='#{BUTTON_CLASS}'>About</button>".html_safe }
      "A short note."
    end
  end
end
