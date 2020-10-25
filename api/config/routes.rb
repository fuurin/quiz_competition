Rails.application.routes.draw do
  scope :admin, module: 'admin' do
    mount_devise_token_auth_for 'Admin', at: 'auth', controllers: {
      sessions: 'admin/auth/sessions'
    }
    resources :quiz_sets, except: %i[new edit]
    resource :quizzes, only: :create
    resources :competitions, param: :rid, only: %i[show create update destroy]
  end
  
  scope :service, module: 'service' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      sessions: 'service/auth/sessions',
      registrations: 'service/auth/registrations'
    }
    resource :competitions, only: :show
    resources :answers, only: %i[index create]
  end
end
