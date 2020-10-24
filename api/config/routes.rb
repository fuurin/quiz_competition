Rails.application.routes.draw do
  get 'quizzes/create'
  resources :hello, only: :index
  scope :admin, module: 'admin' do
    mount_devise_token_auth_for 'Admin', at: 'auth', controllers: {
      sessions: 'admin/auth/sessions'
    }
    resources :quiz_sets, except: %i[new edit]
    resources :quizzes, only: :create
  end
end
