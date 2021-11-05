Rails.application.routes.draw do

  root "statics#landing"

  require 'sidekiq/web'
  authenticate :account, lambda { |a| a.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :accounts, controllers: {registrations: 'accounts/registrations', sessions: 'accounts/sessions'}
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}

  resources :accounts, path: '' do 
    resources :rooms do
      resources :memberships, only: [:create, :delete]
      resources :messages, only: [:create, :delete]
    end
    resource :tokens, only: :create
  end  

  resources :webhook_endpoints

  # API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :messages, only: :create
      resources :memberships, only: :create
      resources :rooms, only: :create
      resources :users, only: :create do 
        member do
          get :login
        end
      end
      match '*path' => 'base#path_not_found', via: :all
    end
  end

end