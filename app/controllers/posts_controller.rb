class PostsController < ApplicationController
before_action :logged_in?, only: [:create, :destroy]
# GETアクション
  def edit
    @posts = User.posts
  end

  def index
    @posts = Post.all
  end

  def new
    @posts = Post.new
  end

  def show
    @posts = Post.find_by(user_id: params[:id])
  end

  # POSTアクション
  def create
    @post = current_user.posts.build(post_params)
    @post.save
    flash[:success] = "新しい投稿をしました"
    redirect_to root_path
  end

  def updated
    @post = current_user.posts.find_by(id: params[:id])
    if @post.update_atributes(post_params)
      @post.save
      flash[:success] = "投稿を編集しました"
      redirect＿to root_path
    else
      redirect_to edit_post_path
    end
  end

  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    @post.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to root_path
  end

  private

   def post_params
     params.require(:post).permit(:image, :body)
   end
end
