Rails.application.routes.draw do
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'

  get 'search', to: 'search#index'

  get     'login',  to:  'sessions#new'
  post    'login',  to:  'sessions#create'
  delete  'logout', to:  'sessions#destroy'

  get 'signup', to: 'users#new'

  root 'links#index'

  resources :users, except: :index
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :links do
    resources :comments, only: [:create, :index, :destroy] do
      member do
        post 'vote'
      end
    end

    member do
      post 'vote'
    end
  end
end
