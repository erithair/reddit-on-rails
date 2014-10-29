Rails.application.routes.draw do
  root 'pages#home'

  get 'signup', to: 'users#new', as: 'signup'
  resources :users, except: :index
end
