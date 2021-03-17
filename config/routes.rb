# == Route Map == [annotate --routes]
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#                      root GET    /                                                                                        posts#index
#                     login GET    /login(.:format)                                                                         user_sessions#new
#                           POST   /login(.:format)                                                                         user_sessions#create
#                    logout DELETE /logout(.:format)                                                                        user_sessions#destroy
#                     users GET    /users(.:format)                                                                         users#index
#                           POST   /users(.:format)                                                                         users#create
#                  new_user GET    /users/new(.:format)                                                                     users#new
#                      user GET    /users/:id(.:format)                                                                     users#show
#              search_posts GET    /posts/search(.:format)                                                                  posts#search
#             post_comments GET    /posts/:post_id/comments(.:format)                                                       comments#index
#                           POST   /posts/:post_id/comments(.:format)                                                       comments#create
#          new_post_comment GET    /posts/:post_id/comments/new(.:format)                                                   comments#new
#              edit_comment GET    /comments/:id/edit(.:format)                                                             comments#edit
#                   comment GET    /comments/:id(.:format)                                                                  comments#show
#                           PATCH  /comments/:id(.:format)                                                                  comments#update
#                           PUT    /comments/:id(.:format)                                                                  comments#update
#                           DELETE /comments/:id(.:format)                                                                  comments#destroy
#                     posts GET    /posts(.:format)                                                                         posts#index
#                           POST   /posts(.:format)                                                                         posts#create
#                  new_post GET    /posts/new(.:format)                                                                     posts#new
#                 edit_post GET    /posts/:id/edit(.:format)                                                                posts#edit
#                      post GET    /posts/:id(.:format)                                                                     posts#show
#                           PATCH  /posts/:id(.:format)                                                                     posts#update
#                           PUT    /posts/:id(.:format)                                                                     posts#update
#                           DELETE /posts/:id(.:format)                                                                     posts#destroy
#                     likes POST   /likes(.:format)                                                                         likes#create
#                      like DELETE /likes/:id(.:format)                                                                     likes#destroy
#             relationships POST   /relationships(.:format)                                                                 relationships#create
#              relationship DELETE /relationships/:id(.:format)                                                             relationships#destroy
#             read_activity PATCH  /activities/:id/read(.:format)                                                           activities#read
#       edit_mypage_account GET    /mypage/account/edit(.:format)                                                           mypage/accounts#edit
#            mypage_account PATCH  /mypage/account(.:format)                                                                mypage/accounts#update
#                           PUT    /mypage/account(.:format)                                                                mypage/accounts#update
#         mypage_activities GET    /mypage/activities(.:format)                                                             mypage/activities#index
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
  root 'posts#index'

  get 'login' => 'user_sessions#new'
  post 'login' => 'user_sessions#create'
  delete 'logout' => 'user_sessions#destroy'

  # ユーザー登録フォーム、ユーザー追加アクションのルーティング
  resources :users, only: %i[index new create show]
  # リソース = postsテーブルにとっての１投稿
  # resources = 基本となる7つのアクションをリクエストするルーティングを設定
  # shallow = リソースの関係性を一意に特定できる際に、不必要なURLを短くできるRailsの
  # ルーティングのオプション
  # edit,show,update,destroyでは /posts/post_id/ を省略する
  # https://kossy-web-engineer.hatenablog.com/entry/2018/10/17/063136
  resources :posts, shallow: true do
    # ネスト = ある記述の中に入れ子構造で別の記述をする方法
    # collection = ルーティングにコレクション（/photos/searchのようにidを伴わないパス）を追加するときに使う。
    collection do
      get :search
    end
    resources :comments
  end
  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :activities, only: [] do
    # on: 名前付きルートを指定
    patch :read, on: :member
  end

  # namespace = URLを指定のPATHにしたくて、ファイル構成も指定のものにしたい時
  # scopeではないのは、この後の課題で違うaccounts_controllerがでてくるから？
  # https://qiita.com/ryosuketter/items/9240d8c2561b5989f049
  namespace :mypage do
    resource :account, only: %i[edit update]
    resources :activities, only: %i[index]
  end
end
