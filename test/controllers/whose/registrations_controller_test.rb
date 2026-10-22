# frozen_string_literal: true

require "test_helper"

class Whose::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  test "sign up creates unconfirmed user and enqueues email" do
    assert_difference("User.count") do
      assert_no_difference("Whose::Session.count") { sign_up }
    end

    user = User.last
    assert_not user.confirmed?
    assert_enqueued_email_with Whose::AuthMailer, :confirmation, args: [ user ]
    assert_redirected_to new_session_path
    assert_equal I18n.t("whose.registrations.created"), flash[:notice]
    assert_nil cookies[:session_id]
  end

  test "sign up with taken email is unprocessable" do
    create(:user, email_address: "ann@example.com")

    assert_no_difference("User.count") { sign_up(email_address: "ANN@Example.com") }

    assert_response :unprocessable_content
    assert_no_enqueued_emails
  end

  test "sign up with mismatched password confirmation is unprocessable" do
    assert_no_difference("User.count") { sign_up(password_confirmation: "different123") }

    assert_response :unprocessable_content
  end

  test "signed in user on sign up page redirects" do
    create(:user, email_address: "ann@example.com")
    post session_path, params: { email_address: "ann@example.com", password: "password123" }

    get new_registration_path

    assert_redirected_to "/dashboard"
  end

  test "signed in user cannot sign up" do
    create(:user, email_address: "ann@example.com")
    post session_path, params: { email_address: "ann@example.com", password: "password123" }

    assert_no_difference("User.count") { sign_up(email_address: "bob@example.com") }

    assert_redirected_to "/dashboard"
    assert_no_enqueued_emails
  end

  test "sign up params override applies" do
    sign_up(name: "Ann")

    assert_equal "Ann", User.last.name
  end

  private

  def sign_up(email_address: "ann@example.com", password: "password123", password_confirmation: password, **extra)
    post registration_path, params: { user: { email_address:, password:, password_confirmation:, **extra } }
  end
end
