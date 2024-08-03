require_relative "lib/whose/components/version"

Gem::Specification.new do |spec|
  spec.name        = "whose-components"
  spec.version     = Whose::Components::VERSION
  spec.authors     = ["WeiHsi Hu"]
  # spec.email       = ["walzerfan@yahoo.com"]
  # spec.homepage    = "TODO"
  spec.summary     = "Whose UI components."
  spec.description = "With viewcomponents, tailwindcss, flowbite."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/"

  spec.metadata["homepage_uri"] = "https://rubygems.pkg.github.com/"
  spec.metadata["github_repo"] = "ssh://github.com/waywho/whose-components"
  spec.metadata["source_code_uri"] = "https://github.com/waywho/whose-components.git"
  spec.metadata["changelog_uri"] = "https://github.com/waywho/whose-components/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.2"
  spec.add_dependency "haml", ">= 6.0.0"
  spec.add_dependency "haml-rails", ">= 2.1.0"
  spec.add_dependency "lookbook", ">= 2.0.0.beta.0", "< 3.0"
  spec.add_dependency "turbo-rails", "= 1.4.0"
  spec.add_dependency "view_component", "~> 3.1"
  spec.add_dependency "view_component-form", "~> 0.2.5"
  spec.add_dependency "tailwindcss-rails", "~> 2.6.5"
end
