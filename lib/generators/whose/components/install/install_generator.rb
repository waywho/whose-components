# frozen_string_literal: true

require "rails/generators/active_record"

module Whose
  module Components
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Rails::Generators::Migration

        ENGINE_CSS_IMPORT = %(@import "../builds/tailwind/whose_components.css";)
        STIMULUS_REGISTRATION = %(eagerLoadControllersFrom("whose/controllers", application))

        source_root File.expand_path("templates", __dir__)

        desc "Add the whose-components styles and Stimulus controllers to the app."

        class_option :auth, type: :boolean, default: false, desc: "Install email and password sign-in"

        def self.next_migration_number(dirname)
          ActiveRecord::Generators::Base.next_migration_number(dirname)
        end

        def add_engine_css
          insert_into_file "app/assets/tailwind/application.css", "#{ENGINE_CSS_IMPORT}\n", after: %(@import "tailwindcss";\n)
        end

        def register_stimulus_controllers
          append_to_file "app/javascript/controllers/index.js", "#{STIMULUS_REGISTRATION}\n"
        end

        def add_authentication
          return unless options[:auth]

          migration_template "create_users.rb", "db/migrate/create_users.rb"
          migration_template "create_sessions.rb", "db/migrate/create_sessions.rb"
          template "user.rb", "app/models/user.rb"
          template "users.rb", "test/factories/users.rb"
          inject_into_class "app/controllers/application_controller.rb", "ApplicationController", "  include Whose::Authentication\n"
          route "whose_authentication"
        end
      end
    end
  end
end
