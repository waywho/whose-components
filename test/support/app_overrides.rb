# frozen_string_literal: true

class DashboardsController < ApplicationController
  def show
    render inline: <<~ERB, layout: "application"
      <h1><%= current_user.email_address %></h1>
      <%= button_to "Sign out", session_path, method: :delete %>
    ERB
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
