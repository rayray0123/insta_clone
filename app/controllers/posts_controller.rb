class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]
  # GETアクション
  def edit
    @post = current_user.posts.find(params[:id])
  end

  def index
    # 投稿データを作成された時間で降順に並べ直して代入
    # postテーブルのuser_idとuserテーブルのidを対応させる方法で二つのテーブルを左外部結合する
    # https://qiita.com/naoki_mochizuki/items/3fda1ad6594c11d7b43c
    # N＋1問題を解決するためにincludesを使いUserとPostをまとめて、一回ずつloadするだけにしている
    # ページネーションをつけたいデータに.page(params[:page])を追加
    # params[:page] 指定されたページ番号が入る
    @posts = if current_user
               # ログインしている場合、自分とフォローしているuserの投稿のみ表示
               current_user.feed.includes(:user).page(params[:page])
             else
               # ログインしていない場合、すべてのuserの投稿を表示
               Post.all.includes(:user).page(params[:page])
             end

    # User.order(created_at: :desc).limit(5)
    @users = User.recent(5)
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    # 上から新しいコメントを表示するために order(created_at: :desc)
    # N+1問題解消のためincludes(:user)
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  # POSTアクション
  def create
    # ここで画像がリサイズされる
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, success: '投稿しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def update
    # find_by = 検索したい条件に合うレコードから最初に一致した１件だけを拾ってくる
    # find = 主キー(ID)を使用して、特定のオブジェクトを検索する
    # IDがわかっている場合は、findメソッド
    # IDが不明で、別の条件でレコード検索をしたい場合は、find_byメソッド
    @post = current_user.posts.find(params[:id])
    # update_atributes updateの別名のメソッド
    if @post.update(post_params)
      redirect_to posts_path success: '投稿を更新しました' # show.html.slimへ
    else
      flash.now[:danger] = '投稿の更新に失敗しました'
      # redirect_to,render = コントローラーを経由するか、そのままビューを表示するか
      # redirectではなくrender もう@post内にすでに投稿内容が入っているから
      # :edit ビューを指定
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    # destroy! = 削除できなかったときエラーが表示される(flashではなく)
    @post.destroy!
    redirect_to root_path, success: '投稿を削除しました'
  end

  def search
    @posts = @search_form.search.includes(:user).page(params[:page])
  end

  private

  def post_params # ストロングパラメータ = Web上から入力されてきた値を制限することで、
    # 不正なパラメータを防ぐ仕組み DBに受け取る値を制限
    params.require(:post).permit(:body, images: []) # requireメソッドでPOSTで受け取る値のキー設定
    # permitメソッドで許可して受け取る値を制限
    # 複数のデータを送るときには[]を付けないといけない(DBに入る前までは配列でデータが送られてくるから)
  end
end
