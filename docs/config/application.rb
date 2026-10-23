# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Docs
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # For compatibility with applications that use this config
    config.action_controller.include_all_helpers = false

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets generators tasks])

    config.view_component.previews.paths << Rails.root.join("../test/components/previews").to_s
    config.view_component.generate.sidecar = true
    config.view_component.generate.preview = true
    config.view_component.generate.preview_path = "test/components/previews"
    config.lookbook.project_name = "Whose Components"
  end
end
