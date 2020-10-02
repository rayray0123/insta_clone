Rails.application.routes.draw do
  root 'posts#index'

  get 'login' => 'user_sessions#new'
  post 'login' => 'user_sessions#create'
  delete 'logout' => 'user_sessions#destroy'

  # ユーザー登録フォーム、ユーザー追加アクションのルーティング
  resources :users, only: %i[new create]
  # リソース = postsテーブルにとっての１投稿
  # resources = 基本となる7つのアクションをリクエストするルーティングを設定
  # shallow = リソースの関係性を一意に特定できる際に、不必要なURLを短くできるRailsの
  # ルーティングのオプション
  # edit,show,update,destroyでは /posts/post_id/ を省略する
  # https://kossy-web-engineer.hatenablog.com/entry/2018/10/17/063136
  resources :posts, shallow: true do
    # ネスト = ある記述の中に入れ子構造で別の記述をする方法
    resources :comments
  end
  resources :posts do
      resources :likes, only: [:create, :destroy]
  end
end
