# frozen_string_literal: true

require "test_helper"

class Whose::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  test "sign up creates unconfirmed user and enqueues email" do
    assert_difference("User.count") do
      assert_no_difference("Whose::Session.count") { sign_up }
    end

    user = User.last
    assert_equal "Ann Lee", user.name
    assert_not user.confirmed?
    assert_enqueued_email_with Whose::AuthMailer, :confirmation, args: [ user ]
    assert_redirected_to new_session_path
    assert_equal I18n.t("whose.registrations.created"), flash[:notice]
    assert_nil cookies[:session_id]
  end

  test "sign up with taken email gives the same response as a new email" do
    owner = create(:user, email_address: "ann@example.com")
    responses = [ "bob@example.com", "ANN@Example.com" ].map do |email_address|
      sign_up(email_address:)
      [ response.status, response.location, flash[:notice] ]
    end

    assert_equal 1, responses.uniq.size
    assert_equal [ 302, new_session_url, I18n.t("whose.registrations.created") ], responses.first
    assert_equal 2, User.count
    assert_enqueued_emails 2
    assert_enqueued_email_with Whose::AuthMailer, :account_exists, args: [ owner ]
  end

  test "invalid sign up with taken email gives the same response as with a new email" do
    sign_up(first_name: "", password_confirmation: "different123")
    new_email_response = [ response.status, response.body ]
    create(:user, email_address: "ann@example.com")

    assert_no_difference("User.count") { sign_up(first_name: "", password_confirmation: "different123") }

    assert_equal 422, new_email_response.first
    assert_equal new_email_response, [ response.status, response.body ]
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

  test "sign up without a first name is unprocessable" do
    assert_no_difference("User.count") { sign_up(first_name: "") }

    assert_response :unprocessable_content
  end

  test "sign up without a last name succeeds" do
    assert_difference("User.count") { sign_up(last_name: "") }

    assert_equal "Ann", User.last.name
  end

  test "sign up params override applies" do
    sign_up(nickname: "Annie")

    assert_equal "Annie", User.last.nickname
  end

  private

  def sign_up(email_address: "ann@example.com", password: "password123", password_confirmation: password,
              first_name: "Ann", last_name: "Lee", **extra)
    post registration_path,
         params: { user: { email_address:, password:, password_confirmation:, first_name:, last_name:, **extra } }
  end
end
