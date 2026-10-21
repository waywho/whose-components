# frozen_string_literal: true

require_relative "lib/whose/components/version"

Gem::Specification.new do |spec|
  spec.name        = "whose-components"
  spec.version     = Whose::Components::VERSION
  spec.authors     = [ "Wei Hsi Hu" ]
  spec.email       = [ "wh@simply.tv" ]
  spec.homepage    = "https://github.com/waywho/whose-components"
  spec.summary     = "ViewComponents, a theme with dark mode, and email-and-password auth for Rails."
  spec.description = "A Rails engine with ViewComponents, a Tailwind theme with dark mode, Stimulus controllers, and optional email-and-password auth."
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.4"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1"
  spec.add_dependency "view_component", "~> 4.0"
  spec.add_dependency "haml-rails", ">= 3.0"
  spec.add_dependency "tailwindcss-rails", ">= 4.6"
  spec.add_dependency "importmap-rails"
  spec.add_dependency "stimulus-rails"
  spec.add_dependency "turbo-rails"
  spec.add_dependency "bcrypt", "~> 3.1"
end
