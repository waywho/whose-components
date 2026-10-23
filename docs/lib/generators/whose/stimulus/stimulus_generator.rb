# frozen_string_literal: true

class Whose::StimulusGenerator < Rails::Generators::NamedBase
  def create_controller
    create_file "app/javascript/whose/controllers/whose_#{class_name.delete_prefix("Whose::").gsub("::", "").underscore}_controller.js", <<~JS
      import { Controller } from "@hotwired/stimulus"

      export default class extends Controller {
        connect() {
        }
      }
    JS
  end
end
