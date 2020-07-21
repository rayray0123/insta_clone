Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
# ユーザー登録フォーム、ユーザー追加アクションのルーティング
  resources :users, only: [:new, :create]
end
