Rails.application.routes.draw do
  namespace :api do
    resources :hello, only: :index
    namespace :admin do
      mount_devise_token_auth_for 'Admin', at: 'auth'
    end
  end
end
