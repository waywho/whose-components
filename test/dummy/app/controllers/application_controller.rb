# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Whose::Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def after_sign_in_path
    dashboard_path
  end

  def sign_up_params
    params.expect(user: %i[first_name last_name email_address password password_confirmation nickname])
  end
end
