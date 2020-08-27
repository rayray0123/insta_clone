class PostsController < ApplicationController
before_action :logged_in?, only: [:create, :destroy]
# GETアクション
  def edit
    @posts = current_ser.posts.find(params[:id])
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
    if @post.save
    flash[:success] = "新しい投稿をしました"
    redirect_to root_path
  end

  def update
    # find_by = 検索したい条件に合うレコードから最初に一致した１件だけを拾ってくる
    # find = 主キー(ID)を使用して、特定のオブジェクトを検索する
    # IDがわかっている場合は、findメソッド
    # IDが不明で、別の条件でレコード検索をしたい場合は、find_byメソッド
    @post = current_user.posts.find(params[:id])
    # update_atributes updateの別名のメソッド
    if @post.update(post_params)
      flash[:success] = "投稿を編集しました"
      redirect＿to post_path # show.html.slimへ
    else
      # redirect_to,render = コントローラーを経由するか、そのままビューを表示するか
      # redirectではなくrender もう@post内にすでに投稿内容が入っているから
      # :edit ビューを指定
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    @post.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to root_path
  end

  private

   def post_params # ストロングパラメータ = Web上から入力されてきた値を制限することで、不正なパラメータを防ぐ仕組み DBに受け取る値を制限
     params.require(:post).permit(:image [], :body) # requireというメソッドでPOSTで受け取る値のキー設定
                                                  # permitメソッドで許可して受け取る値を制限
                                                  # ストロングパラメータにimagesを配列で渡す
   end
end
