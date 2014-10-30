Rails.application.routes.draw do
  get     'login',  to:  'sessions#new'
  post    'login',  to:  'sessions#create'
  delete  'logout', to:  'sessions#destroy'

  get 'signup', to: 'users#new', as: 'signup'

  root 'pages#home'

  resources :users, except: :index
end
