# frozen_string_literal: true

module Whose
  module Components
    class Engine < ::Rails::Engine
      engine_name "whose_components"

      initializer "whose_components.importmap", before: "importmap" do |app|
        app.config.importmap.paths << root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << root.join("app/javascript")
      end

      config.to_prepare do
        ActionController::Base.helper Whose::FormHelper
        ActionController::Base.helper Whose::ComponentHelper
      end

      initializer "whose_components.assets" do |app|
        app.config.assets.paths << root.join("app/javascript")
        app.config.assets.paths << root.join("vendor/javascript")
      end
    end
  end
end
