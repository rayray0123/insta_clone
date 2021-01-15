class ApplicationController < ActionController::Base
  # 全てのコントローラーのアクション実行時にset_search_posts_formメソッドを実行
  before_action :set_search_posts_form
  # bootstrapでフラッシュメッセージを表示できるようにキーを指定
  add_flash_types :success, :info, :warning, :danger

  private

  # require_loginでログインされてないとされたとき実行
  #  (not_authenticated以外のメソッドを指定する場合、config/initializers/sorcery.rbを編集して変更)
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end

  # ヘッダー部分（=共通部分）に検索フォームを置くのでApplicationControllerに実装する
  def set_search_posts_form
    @search_form = SearchPostsForm.new(search_post_params)
  end
  # fetch,{} = 指定したキーがないときにエラーを出さないようにする
  def search_post_params
    params.fetch(:q, {}).permit(:body, :comment_body, :username)
  end
end
