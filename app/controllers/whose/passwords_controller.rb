# frozen_string_literal: true

class Whose::PasswordsController < ::ApplicationController
  include Whose::Authentication

  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_password_path, alert: t("whose.rate_limited") }
  before_action :set_user_by_token, only: %i[edit update]

  def new; end

  def create
    user = User.find_by(email_address: params.expect(:email_address))
    Whose::AuthMailer.password_reset(user).deliver_later if user
    redirect_to new_session_path, notice: t("whose.passwords.sent")
  end

  def edit; end

  def update
    attributes = params.expect(user: %i[password password_confirmation])
    if attributes[:password].present? && User.transaction { @user.update(attributes) && @user.sessions.destroy_all }
      redirect_to new_session_path, notice: t("whose.passwords.updated")
    else
      @user.errors.add(:password, :blank) if attributes[:password].blank?
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound
    redirect_to new_password_path, alert: t("whose.passwords.invalid")
  end
end
