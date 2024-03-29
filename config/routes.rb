Rails.application.routes.draw do
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'

  get 'search', to: 'search#index'

  get     'login',  to:  'sessions#new'
  post    'login',  to:  'sessions#create'
  delete  'logout', to:  'sessions#destroy'

  get 'signup', to: 'users#new'

  root 'links#index'

  resources :users, except: :index do
    member do
      get 'links'
      get 'comments'
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :links do
    resources :comments, only: [:create, :index, :destroy] do
      resources :votes, only: [:create], module: :comments
    end

    resources :votes, only: [:create], module: :links
  end
end
