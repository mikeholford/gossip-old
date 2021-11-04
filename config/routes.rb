Rails.application.routes.draw do

  resources :memberships
  devise_for :users

  resources :rooms
  resources :messages

  root "rooms#index"

end
