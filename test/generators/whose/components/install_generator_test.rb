# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/whose/components/install/install_generator"

class Whose::Components::Generators::InstallGeneratorTest < Rails::Generators::TestCase
  tests Whose::Components::Generators::InstallGenerator
  destination File.expand_path("../../../../tmp/generator", __dir__)

  setup do
    prepare_destination
    write_destination_file "app/assets/tailwind/application.css", %(@import "tailwindcss";\n)
    write_destination_file "app/javascript/controllers/index.js", <<~JS
      import { application } from "controllers/application"
      import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
      eagerLoadControllersFrom("controllers", application)
    JS
    write_destination_file "app/controllers/application_controller.rb", <<~RUBY
      class ApplicationController < ActionController::Base
      end
    RUBY
    write_destination_file "config/routes.rb", <<~RUBY
      Rails.application.routes.draw do
      end
    RUBY
  end

  test "adds engine css import" do
    run_generator

    assert_file "app/assets/tailwind/application.css",
                %(@import "tailwindcss";\n@import "../builds/tailwind/whose_components.css";\n)
  end

  test "registers whose stimulus controllers" do
    run_generator

    assert_file "app/javascript/controllers/index.js", /eagerLoadControllersFrom\("whose\/controllers", application\)/
  end

  test "is idempotent" do
    2.times { run_generator }

    assert_equal 1, File.read(File.join(destination_root, "app/assets/tailwind/application.css")).scan("whose_components.css").size
    assert_equal 1, File.read(File.join(destination_root, "app/javascript/controllers/index.js")).scan("whose/controllers").size
  end

  test "auth option adds migrations model routes and include" do
    run_generator %w[--auth]

    assert_migration "db/migrate/create_users.rb" do |migration|
      assert_match(/t\.string :email_address, null: false/, migration)
      assert_match(/t\.string :password_digest, null: false/, migration)
      assert_match(/t\.datetime :confirmed_at/, migration)
      assert_match(/add_index :users, :email_address, unique: true/, migration)
    end
    assert_migration "db/migrate/create_whose_sessions.rb" do |migration|
      assert_match(/class CreateWhoseSessions /, migration)
      assert_match(/create_table :whose_sessions do/, migration)
      assert_match(/t\.references :user, null: false, foreign_key: true/, migration)
      assert_match(/t\.string :ip_address/, migration)
      assert_match(/t\.string :user_agent/, migration)
      assert_match(/t\.timestamps/, migration)
    end
    assert_file "app/models/user.rb", /include Whose::Authenticatable/
    assert_file "app/controllers/application_controller.rb", /class ApplicationController < ActionController::Base\n  include Whose::Authentication\n/
    assert_file "config/routes.rb", /\n  whose_authentication\n/
    assert_file "test/factories/users.rb", /factory :user do/
  end

  test "without auth option adds none" do
    run_generator

    assert_no_migration "db/migrate/create_users.rb"
    assert_no_migration "db/migrate/create_whose_sessions.rb"
    assert_no_file "app/models/user.rb"
    assert_no_file "test/factories/users.rb"
    assert_file "app/controllers/application_controller.rb" do |content|
      assert_no_match(/Whose::Authentication/, content)
    end
    assert_file "config/routes.rb" do |content|
      assert_no_match(/whose_authentication/, content)
    end
  end

  private

  def write_destination_file(path, content)
    full_path = File.join(destination_root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, content)
  end
end
