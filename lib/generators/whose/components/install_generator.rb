module Whose
  module Components
    class InstallGenerator < Rails::Generators::Base
      desc "Install Whose Components dependencies including Tailwind CSS, ViewComponent, and Lookbook"

      def install_tailwindcss
        say "Installing Tailwind CSS via tailwindcss-rails..."
        rake "tailwindcss:install"
      end

      def configure_view_component
        say "Configuring ViewComponent..."
        inject_into_class "config/application.rb", "Application" do
          <<-RUBY

    # ViewComponent
    config.view_component.generate_sidecar = true
    config.view_component.generate.preview = true
    config.view_component.default_preview_layout = "component_preview"
          RUBY
        end
      end

      def configure_lookbook
        say "Mounting Lookbook in development routes..."
        inject_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
          <<-RUBY
  mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?
          RUBY
        end
      end

      def create_preview_directory
        say "Creating component preview directory..."
        empty_directory "test/components/previews"
      end
    end
  end
end
