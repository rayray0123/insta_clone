Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#home'
# ユーザー登録フォーム、ユーザー追加アクションのルーティング
  resources :users, only: [:new, :create]

  get 'welcome' => 'user_sessions#new', :as => :welcome
  post 'login' => 'user_sessions#create', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
end
