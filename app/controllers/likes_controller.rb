class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @post = Post.find(params[:post_id])
    # current_user.like_postsで得られる投稿（ログインユーザーがいいねした投稿）に、
    # 今いいねした投稿を追加。このときlikeテーブルに新しくレコードが作られる。
    # 投稿へのいいねの通知メールを送る
    UserMailer.with(user_from: current_user, user_to: @post.user, post: @post).like_post.deliver_later if current_user.like(@post)
  end

  def destroy
    # 送られてきたいいねと紐づいている投稿を取得
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
