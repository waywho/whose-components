module Whose
  module Components
    class InstallGenerator < Rails::Generators::Base
      desc "Install Whose Components dependencies including Tailwind CSS"

      def install_tailwindcss
        say "Installing Tailwind CSS via tailwindcss-rails..."
        rake "tailwindcss:install"
      end
    end
  end
end
