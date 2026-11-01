# frozen_string_literal: true

module Whose
  module Components
    class Engine < ::Rails::Engine
      engine_name "whose_components"
      config.generators.template_engine :haml

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

      # engine.css is a Tailwind source, not an asset that the pipeline serves.
      # Propshaft would compile it and warn about its font URL, which resolves
      # against the built tailwind.css instead. tailwindcss-rails excludes the
      # app's own Tailwind source the same way.
      initializer "whose_components.exclude_tailwind_source", before: "propshaft.append_assets_path" do |app|
        app.config.assets.excluded_paths&.push(root.join("app/assets/tailwind"))
      end
    end
  end
end
