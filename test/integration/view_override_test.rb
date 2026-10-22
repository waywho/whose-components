# frozen_string_literal: true

require "test_helper"

class ViewOverrideTest < ActionDispatch::IntegrationTest
  setup do
    @app_view = Rails.root.join("app/views/whose/passwords/new.html.haml")
    @created_folder = !Rails.root.join("app/views/whose").exist?
    FileUtils.mkdir_p(@app_view.dirname)
    File.write(@app_view, "%p App copy\n")
    ActionView::LookupContext::DetailsKey.clear
  end

  teardown do
    FileUtils.rm_f(@app_view)
    FileUtils.rm_rf(Rails.root.join("app/views/whose")) if @created_folder
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
