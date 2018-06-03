Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "posts#index"

  # _post_nav 顯示異常修正：點選分類後按 sort_link，all 分類會變 active
  resources :categories, only: [:show]

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
      get :collections
      get :friends
    end
  end

  resources :friendships, only: :create do
    member do
      post   :accept
      delete :ignore
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

  namespace :admin do
    root "categories#index"
    resources :categories
    resources :users, only: [:index, :update]
  end

end
