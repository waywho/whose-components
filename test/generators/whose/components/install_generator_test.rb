# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/whose/components/install/install_generator"

class Whose::Components::Generators::InstallGeneratorTest < Rails::Generators::TestCase
  tests Whose::Components::Generators::InstallGenerator
  # Tests run in parallel processes, and a shared folder lets one process delete another's files.
  def destination_root = File.expand_path("../../../../tmp/generator/#{Process.pid}", __dir__)

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

  test "writes haml layout and removes erb" do
    write_destination_file "app/views/layouts/application.html.erb", "<html></html>"

    run_generator

    assert_no_file "app/views/layouts/application.html.erb"
    assert_file "app/views/layouts/application.html.haml" do |layout|
      assert_match(/stylesheet_link_tag "tailwind"/, layout)
      assert_no_match(/stylesheet_link_tag :app/, layout)
      assert_match(/javascript_importmap_tags/, layout)
      assert_match(/csrf_meta_tags/, layout)
      assert_match(/csp_meta_tag/, layout)
      assert_match(/viewport/, layout)
      assert_match(/%body\.bg-canvas\.text-fg\.font-sans/, layout)
      assert_match(/Whose::NavComponent/, layout)
      assert_no_match(/root_path/, layout)
      assert_match(/href: "\/"/, layout)
      assert_match(/%html\{ lang: "en" \}/, layout)
      assert_match(/Whose::FlashComponent/, layout)
      assert_match(/%main/, layout)
      assert_match(%r{rel: "icon", href: "/icon.png"}, layout)
      assert_match(%r{rel: "icon", href: "/icon.svg"}, layout)
      assert_match(%r{rel: "apple-touch-icon", href: "/icon.png"}, layout)
      assert_no_match(/sign_out/, layout)
    end
  end

  test "layout shows the sign out button only to signed-in users with auth" do
    run_generator %w[--auth]

    assert_file "app/views/layouts/application.html.haml" do |layout|
      assert_match(/^      - if authenticated\?\n        - nav\.with_actions \{ button_to t\("whose\.nav\.sign_out"\), session_path, method: :delete \}$/, layout)
    end
  end

  test "is idempotent" do
    2.times { run_generator }

    assert_equal [ "application.html.haml" ], Dir.children(File.join(destination_root, "app/views/layouts"))
    assert_equal 1, File.read(File.join(destination_root, "app/views/layouts/application.html.haml")).scan("Whose::NavComponent").size

    assert_equal 1, File.read(File.join(destination_root, "app/assets/tailwind/application.css")).scan("whose_components.css").size
    assert_equal 1, File.read(File.join(destination_root, "app/javascript/controllers/index.js")).scan("whose/controllers").size
  end

  test "auth option adds migrations model routes and include" do
    run_generator %w[--auth]

    assert_migration "db/migrate/create_users.rb" do |migration|
      assert_match(/\A# frozen_string_literal: true\n/, migration)
      assert_match(/t\.string :email_address, null: false/, migration)
      assert_match(/t\.string :password_digest, null: false/, migration)
      assert_match(/t\.datetime :confirmed_at/, migration)
      assert_match(/t\.string :first_name, null: false/, migration)
      assert_match(/t\.string :last_name\n/, migration)
      assert_match(/t\.string :name, null: false/, migration)
      assert_match(/add_index :users, :email_address, unique: true/, migration)
    end
    assert_migration "db/migrate/create_whose_sessions.rb" do |migration|
      assert_match(/\A# frozen_string_literal: true\n/, migration)
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
