class ApplicationController < ActionController::Base
  before_action :set_search_posts_form
  # bootstrapでフラッシュメッセージを表示できるようにキーを指定
  add_flash_types :success, :info, :warning, :danger

  private

  # require_loginでログインされてないとされたとき実行
  #  (not_authenticated以外のメソッドを指定する場合、config/initializers/sorcery.rbを編集して変更)
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end

  def set_search_posts_form
    @search_form = SearchPostsForm.new(search_post_params)
  end

  def search_post_params
    params.fetch(:q, {}).permit(:body)
  end
end
