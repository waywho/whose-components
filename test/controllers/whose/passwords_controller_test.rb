# frozen_string_literal: true

require "test_helper"

class Whose::PasswordsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  setup { @user = create(:user, email_address: "ann@example.com", password: "old-password-1") }

  test "reset request same response for unknown email" do
    unconfirmed = create(:user, :unconfirmed)
    responses = [ "ANN@example.com", "nobody@example.com", unconfirmed.email_address ].map do |email_address|
      post passwords_path, params: { email_address: }
      [ response.status, response.location, flash[:notice] ]
    end

    assert_equal 1, responses.uniq.size
    assert_equal [ 302, new_session_url, I18n.t("whose.passwords.sent") ], responses.first
    assert_enqueued_emails 2
    assert_enqueued_email_with Whose::AuthMailer, :password_reset, args: [ @user ]
  end

  test "reset page does not change anything" do
    assert_no_changes -> { @user.reload.password_digest } do
      get edit_password_path(token)
    end

    assert_response :success
    assert_no_difference("Whose::Session.count") { get edit_password_path(token) }
  end

  test "request page renders" do
    get new_password_path

    assert_response :success
  end

  test "reset changes password and ends sessions" do
    2.times { @user.sessions.create! }

    patch password_path(token), params: { user: { password: "new-password-1", password_confirmation: "new-password-1" } }

    assert_redirected_to new_session_path
    assert_equal I18n.t("whose.passwords.updated"), flash[:notice]
    assert @user.reload.authenticate("new-password-1")
    assert_equal 0, @user.sessions.count
  end

  test "reset link works once" do
    link = password_path(token)
    patch link, params: { user: { password: "new-password-1", password_confirmation: "new-password-1" } }

    patch link, params: { user: { password: "other-password-1", password_confirmation: "other-password-1" } }

    assert_redirected_to new_password_path
    assert_equal I18n.t("whose.passwords.invalid"), flash[:alert]
    assert @user.reload.authenticate("new-password-1")
  end

  test "reset does not confirm an unconfirmed user" do
    user = create(:user, :unconfirmed)

    patch password_path(user.password_reset_token),
          params: { user: { password: "new-password-1", password_confirmation: "new-password-1" } }

    assert_not user.reload.confirmed?
    assert user.authenticate("new-password-1")
  end

  test "invalid token redirects with message" do
    get edit_password_path("nope")

    assert_redirected_to new_password_path
    assert_equal I18n.t("whose.passwords.invalid"), flash[:alert]

    patch password_path("nope"), params: { user: { password: "new-password-1", password_confirmation: "new-password-1" } }

    assert_redirected_to new_password_path
    assert_equal I18n.t("whose.passwords.invalid"), flash[:alert]
  end

  test "token of a deleted user redirects with message" do
    link = edit_password_path(token)
    @user.destroy

    get link

    assert_redirected_to new_password_path
    assert_equal I18n.t("whose.passwords.invalid"), flash[:alert]
  end

  test "expired token redirects with message" do
    link = edit_password_path(token)

    travel 20.minutes do
      get link
    end

    assert_redirected_to new_password_path
    assert_equal I18n.t("whose.passwords.invalid"), flash[:alert]
  end

  test "mismatched confirmation is unprocessable" do
    patch password_path(token), params: { user: { password: "new-password-1", password_confirmation: "different-1" } }

    assert_response :unprocessable_content
    assert @user.reload.authenticate("old-password-1")
  end

  test "blank password is unprocessable and keeps sessions" do
    @user.sessions.create!

    patch password_path(token), params: { user: { password: "", password_confirmation: "" } }

    assert_response :unprocessable_content
    assert @user.reload.authenticate("old-password-1")
    assert_equal 1, @user.sessions.count
  end

  private

  def token
    @user.password_reset_token
  end
end
