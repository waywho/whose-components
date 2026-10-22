# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  whose_authentication
  resource :dashboard, only: :show

  mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?
end
