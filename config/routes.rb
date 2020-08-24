Rails.application.routes.draw do

  root 'posts#index'

  get 'login' => 'user_sessions#new'
  post 'login' => 'user_sessions#create'
  delete 'logout' => 'user_sessions#destroy'

  # ユーザー登録フォーム、ユーザー追加アクションのルーティング
  resources :users, only: %i[new create]
  # リソース = postsテーブルにとっての１投稿
  # resources = 基本となる7つのアクションをリクエストするルーティングを設定
  resources :posts
end
