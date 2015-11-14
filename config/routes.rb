Rails.application.routes.draw do
  root 'home#index'

  get '/auth/pocket/callback', to: 'sessions#create'
  delete "/sign_out", to: "sessions#destroy"

  resource :settings, only: [:show, :update]
end
