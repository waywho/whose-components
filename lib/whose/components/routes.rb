# frozen_string_literal: true

module Whose
  module Components
    module Routes
      def whose_authentication
        resource :session, only: %i[new create destroy], controller: "whose/sessions"
        resource :registration, only: %i[new create], controller: "whose/registrations"
        resources :confirmations, only: %i[new create show update], param: :token, controller: "whose/confirmations"
      end
    end
  end
end

ActionDispatch::Routing::Mapper.include(Whose::Components::Routes)
