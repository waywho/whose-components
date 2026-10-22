# frozen_string_literal: true

class DashboardsController < ApplicationController
  def show
    head :ok
  end
end

ApplicationController.class_eval do
  private

  def after_sign_in_path
    dashboard_path
  end

  def sign_up_params
    params.expect(user: %i[first_name last_name email_address password password_confirmation nickname])
  end
end

Rails.application.routes.append do
  resource :dashboard, only: :show
end
Rails.application.reload_routes!
