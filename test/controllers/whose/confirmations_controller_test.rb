# frozen_string_literal: true

require "test_helper"

class Whose::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  setup { @user = create(:user, :unconfirmed, email_address: "ann@example.com") }

  test "confirmation link page does not confirm or sign in" do
    assert_no_difference("Whose::Session.count") { get confirmation_path(token) }

    assert_response :success
    assert_not @user.reload.confirmed?
    assert_nil cookies[:session_id]
  end

  test "confirmation link confirms and signs in" do
    assert_difference("Whose::Session.count") { patch confirmation_path(token) }

    assert @user.reload.confirmed?
    assert_redirected_to "/dashboard"
    assert_equal I18n.t("whose.confirmations.confirmed"), flash[:notice]
  end

  test "confirmation link works once" do
    link = confirmation_path(token)
    patch link

    assert_no_difference("Whose::Session.count") { patch link }

    assert_redirected_to new_confirmation_path
    assert_equal I18n.t("whose.confirmations.invalid"), flash[:alert]
  end

  test "expired confirmation link fails" do
    link = confirmation_path(token)

    travel 3.days do
      assert_no_difference("Whose::Session.count") { patch link }
    end

    assert_not @user.reload.confirmed?
    assert_redirected_to new_confirmation_path
    assert_equal I18n.t("whose.confirmations.invalid"), flash[:alert]
  end

  test "resend gives same response for unknown email" do
    responses = [ "ANN@example.com", "nobody@example.com", create(:user).email_address ].map do |email_address|
      post confirmations_path, params: { email_address: }
      [ response.status, response.location, flash[:notice] ]
    end

    assert_equal 1, responses.uniq.size
    assert_equal [ 302, new_session_url, I18n.t("whose.confirmations.sent") ], responses.first
    assert_enqueued_emails 1
    assert_enqueued_email_with Whose::AuthMailer, :confirmation, args: [ @user ]
  end

  test "resend page renders" do
    get new_confirmation_path

    assert_response :success
  end

  private

  def token
    @user.generate_token_for(:email_confirmation)
  end
end
