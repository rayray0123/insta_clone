Rails.application.routes.draw do
  constraints ->  request { request.session[:user_id].present? } do
    # ログインしてる時のルートパス
    root 'posts#index'
  end
  # ログインしてない時のルートパス
  root 'user_sessions#new'

  get 'login' => 'user_sessions#new'
  post 'login' => 'user_sessions#create'
  delete 'logout' => 'user_sessions#destroy'

  # ユーザー登録フォーム、ユーザー追加アクションのルーティング
  resources :users, only: %i[new create]
  resources :posts
end
