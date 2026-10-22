# frozen_string_literal: true

module Whose
  module Components
    module Routes
      def whose_authentication
        resource :session, only: %i[new create destroy], controller: "whose/sessions"
      end
    end
  end
end

ActionDispatch::Routing::Mapper.include(Whose::Components::Routes)
