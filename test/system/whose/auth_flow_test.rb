# frozen_string_literal: true

require "application_system_test_case"

class Whose::AuthFlowSystemTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup { ActionMailer::Base.deliveries.clear }

  def test_sign_up_without_last_name_then_confirm_by_mail_link
    visit new_registration_path
    fill_in "First name", with: "Ann"
    fill_in "Email address", with: "ann@example.com"
    fill_in "Password", with: "password123", exact: true
    fill_in "Confirm the password", with: "password123"
    click_button "Sign up"

    assert_current_path new_session_path
    assert_text I18n.t("whose.registrations.created")
    perform_enqueued_jobs
    visit mail_link

    click_button "Confirm email address"

    assert_current_path dashboard_path
    assert_text I18n.t("whose.confirmations.confirmed")
    assert_text "ann@example.com"
    assert_equal "Ann", User.find_by!(email_address: "ann@example.com").name
  end

  def test_wrong_password_shows_one_alert_and_right_password_signs_in
    create(:user, email_address: "ann@example.com")

    sign_in_with "ann@example.com", "wrong-password"

    assert_selector "[role=alert]", count: 1, text: I18n.t("whose.sessions.invalid")
    assert_current_path session_path

    sign_in_with "ann@example.com", "password123"

    assert_current_path dashboard_path
    assert_text "ann@example.com"
  end

  def test_unconfirmed_user_can_open_the_resend_page
    create(:user, :unconfirmed, email_address: "bob@example.com")

    sign_in_with "bob@example.com", "password123"

    assert_selector "[role=alert]", text: I18n.t("whose.sessions.unconfirmed")
    click_link I18n.t("whose.sessions.new.resend")
    assert_current_path new_confirmation_path
    assert_selector "h1", text: I18n.t("whose.confirmations.new.title")
  end

  def test_confirmed_user_does_not_see_the_resend_link
    create(:user, email_address: "ann@example.com")

    sign_in_with "ann@example.com", "wrong-password"

    assert_no_link I18n.t("whose.sessions.new.resend")
  end

  def test_forgot_password_link_opens_the_reset_form
    visit new_session_path

    click_link "Forgot your password?"

    assert_current_path new_password_path
    assert_selector "h1", text: I18n.t("whose.passwords.new.title")
  end

  def test_reset_password_by_mail_link_then_sign_in_with_the_new_password
    create(:user, email_address: "ann@example.com")

    visit new_password_path
    fill_in "Email address", with: "ann@example.com"
    click_button "Send the link"

    assert_current_path new_session_path
    assert_text I18n.t("whose.passwords.sent")
    perform_enqueued_jobs
    visit mail_link
    fill_in "New password", with: "new-password456", exact: true
    fill_in "Confirm the new password", with: "new-password456"
    click_button "Change password"

    assert_current_path new_session_path
    assert_text I18n.t("whose.passwords.updated")
    sign_in_with "ann@example.com", "new-password456"
    assert_current_path dashboard_path
  end

  def test_sign_out_ends_the_session
    create(:user, email_address: "ann@example.com")
    sign_in_with "ann@example.com", "password123"
    assert_current_path dashboard_path

    click_button "Sign out"

    assert_current_path new_session_path
    assert_text I18n.t("whose.sessions.signed_out")
    visit dashboard_path
    assert_current_path new_session_path
  end

  private

  def sign_in_with(email_address, password)
    visit new_session_path
    fill_in "Email address", with: email_address
    fill_in "Password", with: password
    click_button "Sign in"
  end

  def mail_link
    URI(ActionMailer::Base.deliveries.last.text_part.decoded[%r{https?://\S+}]).request_uri
  end
end
