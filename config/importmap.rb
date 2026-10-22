# frozen_string_literal: true

pin_all_from Whose::Components::Engine.root.join("app/javascript/whose/controllers"), under: "whose/controllers"
pin "@stimulus-components/dialog", to: "@stimulus-components--dialog.js" # @1.0.1
pin "@stimulus-components/notification", to: "@stimulus-components--notification.js" # @3.0.0
pin "@stimulus-components/password-visibility", to: "@stimulus-components--password-visibility.js" # @3.0.0
pin "stimulus-use", to: "stimulus-use.js" # @0.52.3
