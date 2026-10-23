# frozen_string_literal: true

class Whose::RegistrationsController < ::ApplicationController
  include Whose::Authentication

  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_registration_path, alert: t("whose.rate_limited") }
  before_action -> { redirect_to after_sign_in_path if authenticated? }

  def new
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
    if @user.save
      after_sign_up(@user)
      Whose::AuthMailer.confirmation(@user).deliver_later
    else
      @user.errors.delete(:email_address, :taken)
      return render :new, status: :unprocessable_content if @user.errors.any?

      owner = User.find_by!(email_address: @user.email_address)
      (owner.confirmed? ? Whose::AuthMailer.account_exists(owner) : Whose::AuthMailer.confirmation(owner)).deliver_later
    end
    redirect_to after_sign_up_path, notice: t("whose.registrations.created")
  end
end
