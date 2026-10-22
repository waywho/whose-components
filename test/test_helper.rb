# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require_relative "../docs/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../docs/db/migrate", __dir__) ]
require "rails/test_help"
require_relative "support/app_overrides"

FactoryBot.definition_file_paths = [ File.expand_path("factories", __dir__) ]
FactoryBot.find_definitions

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  include FactoryBot::Syntax::Methods
end
