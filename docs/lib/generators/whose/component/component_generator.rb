# frozen_string_literal: true

require "generators/view_component/component/component_generator"

class Whose::ComponentGenerator < ViewComponent::Generators::ComponentGenerator
  source_root superclass.source_root

  remove_hook_for :stimulus
  hook_for :stimulus, type: :boolean, desc: "Add a whose-* Stimulus controller in app/javascript/whose/controllers/"

  def initialize(args, *)
    super([ "Whose::#{args.first.delete_prefix("Whose::")}", *args.drop(1) ], *)
  end

  def add_helper
    inject_into_file "app/helpers/whose/component_helper.rb",
      "  def #{class_name.delete_prefix("Whose::").gsub("::", "").underscore}_component(*, **, &) = render(#{class_name}Component.new(*, **), &)\n",
      before: /^end/
  end
end
