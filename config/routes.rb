Rails.application.routes.draw do
  get 'votes/create'

  get     'login',  to:  'sessions#new'
  post    'login',  to:  'sessions#create'
  delete  'logout', to:  'sessions#destroy'

  get 'signup', to: 'users#new'

  root 'links#index'

  resources :users, except: :index
  resources :links do
    resources :comments, only: [:create, :index, :destroy]
    member do
      post 'vote'
    end
  end
end
