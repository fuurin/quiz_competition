Rails.application.routes.draw do
  scope :api, module: 'api' do
    resources :hello, only: :index
    scope :admin, module: 'admin' do
      mount_devise_token_auth_for 'Admin', at: 'auth', controllers: {
        sessions: 'api/admin/auth/sessions'
      }
      resources :quiz_sets, except: %i[new edit]
    end
  end
end
