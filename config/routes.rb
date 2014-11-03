Rails.application.routes.draw do
  get     'login',  to:  'sessions#new'
  post    'login',  to:  'sessions#create'
  delete  'logout', to:  'sessions#destroy'

  get 'signup', to: 'users#new'

  root 'links#index'

  resources :users, except: :index
  resources :links
end
