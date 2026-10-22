# frozen_string_literal: true

module Whose
  module Components
    module Generators
      class InstallGenerator < Rails::Generators::Base
        ENGINE_CSS_IMPORT = %(@import "../builds/tailwind/whose_components.css";)
        STIMULUS_REGISTRATION = %(eagerLoadControllersFrom("whose/controllers", application))

        desc "Add the whose-components styles and Stimulus controllers to the app."

        class_option :auth, type: :boolean, default: false, desc: "Install email and password sign-in"

        def add_engine_css
          insert_into_file "app/assets/tailwind/application.css", "#{ENGINE_CSS_IMPORT}\n", after: %(@import "tailwindcss";\n)
        end

        def register_stimulus_controllers
          append_to_file "app/javascript/controllers/index.js", "#{STIMULUS_REGISTRATION}\n"
        end
      end
    end
  end
end
