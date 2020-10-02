class LikesController < ApplicationController
  def create
    @like = Post.find(params[:post_id]).likes.build
    @like.save
    @post = Post.find(params[:post_id])
  end

  def destroy
    @like = Likes.find(params[:likes][:post_id])
    @like.destroy!
  end
end
