# frozen_string_literal: true

require "test_helper"

class Whose::AuthMailerTest < ActionMailer::TestCase
  test "confirmation sends a link that confirms the user" do
    user = create(:user, :unconfirmed, email_address: "ann@example.com")

    mail = Whose::AuthMailer.confirmation(user)

    assert_equal [ "ann@example.com" ], mail.to
    assert_equal I18n.t("whose.auth_mailer.confirmation.subject"), mail.subject
    token = mail.text_part.body.to_s[%r{http://example\.com/confirmations/(\S+)}, 1]
    assert_equal user, User.find_by_token_for(:email_confirmation, token)
    assert_includes mail.html_part.body.to_s, "http://example.com/confirmations/#{token}"
  end
end
