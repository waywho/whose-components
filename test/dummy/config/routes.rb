Rails.application.routes.draw do
  mount Whose::Components::Engine => "/whose-components"
end
