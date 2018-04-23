Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "posts#index"

  resources :posts do
    resources :comments, only: [:create, :update, :destroy]
  end

  resources :users, only: [:show, :edit, :update] do
    member do
      get :drafts
      get :comments
    end
  end

  resources :feeds, only: :index
end
