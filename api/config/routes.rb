Rails.application.routes.draw do
  resources :hello, only: :index
  
  scope :admin, module: 'admin' do
    mount_devise_token_auth_for 'Admin', at: 'auth', controllers: {
      sessions: 'admin/auth/sessions'
    }
    resources :quiz_sets, except: %i[new edit]
    resource :quizzes, only: :create
    resources :competitions, param: :rid, only: %i[show create update destroy]
  end
  
  scope :service, module: 'service' do
    resources :competitions, param: :rid, only: :show
  end
end
