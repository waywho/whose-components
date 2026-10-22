# frozen_string_literal: true

class Whose::AuthMailer < ::ApplicationMailer
  def confirmation(user)
    @token = user.generate_token_for(:email_confirmation)
    mail to: user.email_address
  end

  def password_reset(user)
    @token = user.password_reset_token
    mail to: user.email_address
  end
end
