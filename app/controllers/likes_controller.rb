class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    @like = current_user. #?
    @like.save
  end

  def destroy
    @like = Like.find(params[:like][:id])
    current_user.unlike(@post)
    @like.destroy!
  end
end
