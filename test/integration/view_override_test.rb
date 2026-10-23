# frozen_string_literal: true

require "test_helper"

class ViewOverrideTest < ActionDispatch::IntegrationTest
  setup do
    @app_view = Rails.root.join("app/views/whose/passwords/new.html.haml")
    @created_folders = [ @app_view.dirname.parent, @app_view.dirname ].reject(&:exist?)
    FileUtils.mkdir_p(@app_view.dirname)
    File.write(@app_view, "%p App copy\n")
    ActionView::LookupContext::DetailsKey.clear
  end

  teardown do
    FileUtils.rm_f(@app_view)
    @created_folders.reverse_each { Dir.rmdir(it) }
    ActionView::LookupContext::DetailsKey.clear
  end

  test "app view replaces gem view" do
    identifiers = []
    subscriber = ActiveSupport::Notifications.subscribe("render_template.action_view") { |event| identifiers << event.payload[:identifier] }

    get new_password_path

    assert_response :success
    assert_includes identifiers, @app_view.to_s
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end
end
