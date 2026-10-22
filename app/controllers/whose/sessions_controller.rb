# frozen_string_literal: true

class Whose::SessionsController < ::ApplicationController
  include Whose::Authentication

  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: t("whose.sessions.rate_limited") }

  def new
    redirect_to after_sign_in_path if authenticated?
  end

  def create
    credentials = params.permit(:email_address, :password)
    if (user = User.authenticate_by(email_address: credentials[:email_address], password: credentials[:password]))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      flash.now[:alert] = t("whose.sessions.invalid")
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    terminate_session
    redirect_to after_sign_out_path, status: :see_other, notice: t("whose.sessions.signed_out")
  end
end
