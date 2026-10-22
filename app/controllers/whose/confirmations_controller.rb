# frozen_string_literal: true

class Whose::ConfirmationsController < ::ApplicationController
  include Whose::Authentication

  allow_unauthenticated_access only: %i[new create show update]
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_confirmation_path, alert: t("whose.rate_limited") }

  def new; end

  def create
    user = User.find_by(email_address: params.expect(:email_address))
    Whose::AuthMailer.confirmation(user).deliver_later if user && !user.confirmed?
    redirect_to new_session_path, notice: t("whose.confirmations.sent")
  end

  def show; end

  def update
    if (user = User.find_by_token_for(:email_confirmation, params[:token]))
      user.confirm!
      start_new_session_for user
      redirect_to after_sign_in_path, notice: t("whose.confirmations.confirmed")
    else
      redirect_to new_confirmation_path, alert: t("whose.confirmations.invalid")
    end
  end
end
