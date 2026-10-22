# frozen_string_literal: true

module Whose
  module Components
    module Generators
      class ViewsGenerator < Rails::Generators::Base
        source_root Whose::Components::Engine.root.join("app/views/whose")

        desc "Copy the whose-components auth views into the app."

        def copy_views
          %w[sessions registrations confirmations passwords auth_mailer].each do |folder|
            directory folder, "app/views/whose/#{folder}"
          end
        end
      end
    end
  end
end
