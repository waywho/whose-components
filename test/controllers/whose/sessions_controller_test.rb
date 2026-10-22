# frozen_string_literal: true

require "test_helper"

class Whose::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = create(:user, email_address: "ann@example.com") }

  test "sign in with valid credentials creates session and redirects" do
    assert_difference("Whose::Session.count") { sign_in }

    assert_redirected_to "/dashboard"
    assert_equal Whose::Session.last.id, signed_cookies[:session_id]
    session_cookie = response.headers["Set-Cookie"].find { it.start_with?("session_id=") }
    assert_match(/; expires=.*; httponly; samesite=lax/i, session_cookie)
  end

  test "sign in with wrong password is unprocessable" do
    assert_no_difference("Whose::Session.count") { sign_in(password: "wrong-password") }

    assert_response :unprocessable_content
    assert_equal I18n.t("whose.sessions.invalid"), flash[:alert]
  end

  test "sign in with unknown email gives the same response as a wrong password" do
    assert_no_difference("Whose::Session.count") { sign_in(email_address: "nobody@example.com") }

    assert_response :unprocessable_content
    assert_equal I18n.t("whose.sessions.invalid"), flash[:alert]
  end

  test "unconfirmed user cannot sign in" do
    create(:user, :unconfirmed, email_address: "bob@example.com")

    assert_no_difference("Whose::Session.count") { sign_in(email_address: "bob@example.com") }

    assert_response :unprocessable_content
    assert_equal I18n.t("whose.sessions.unconfirmed"), flash[:alert]
    assert_nil cookies[:session_id]
  end

  test "sign in without a password parameter is unprocessable" do
    post session_path, params: { email_address: "ann@example.com" }

    assert_response :unprocessable_content
    assert_equal I18n.t("whose.sessions.invalid"), flash[:alert]
  end

  test "signed in user on sign in page redirects" do
    sign_in

    get new_session_path

    assert_redirected_to "/dashboard"
  end

  test "sign out destroys session" do
    sign_in

    assert_difference("Whose::Session.count", -1) { delete session_path }

    assert_redirected_to new_session_path
    assert_equal I18n.t("whose.sessions.signed_out"), flash[:notice]
    get dashboard_path
    assert_redirected_to new_session_path
  end

  test "protected page redirects to sign in and returns there after sign in" do
    get dashboard_path(tab: "recent")

    assert_redirected_to new_session_path

    sign_in

    assert_redirected_to dashboard_url(tab: "recent")
  end

  test "no auth routes without mapper call" do
    assert_nil Whose::Components::Engine.routes.named_routes[:session]

    routes = ActionDispatch::Routing::RouteSet.new
    routes.draw { whose_authentication }

    assert_equal "/session/new", routes.url_helpers.new_session_path
  end

  test "default after sign in path is slash when the app has no root route" do
    controller_class = Class.new(ActionController::Base) do
      include Rails.application.routes.mounted_helpers
      include Whose::Authentication
    end

    assert_equal "/", controller_class.new.send(:after_sign_in_path)
  end

  private

  def sign_in(email_address: "ANN@example.com", password: "password123")
    post session_path, params: { email_address:, password: }
  end

  def signed_cookies
    ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash).signed
  end
end
