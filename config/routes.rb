Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "posts#index"

  resources :posts do
    resources :comments, only: [:create, :destroy]
    member do
      get :edit_comment
      post :collect
      post :uncollect
    end
  end

  resources :users, only: [:show, :edit, :update] do
    member do
      get :drafts
      get :comments
    end
  end

  resources :feeds, only: :index

  namespace :api, defaults: {format: :json} do
    namespace :v1 do

      post "/login" => "auth#login"
      post "/logout" => "auth#logout"

      resources :posts, only: [:index, :create, :show, :update, :destroy]
    end
  end

end
