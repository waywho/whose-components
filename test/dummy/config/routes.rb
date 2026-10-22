# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?
end
