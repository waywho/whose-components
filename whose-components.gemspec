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
