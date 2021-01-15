class ApplicationController < ActionController::Base
  # bootstrapでフラッシュメッセージを表示できるようにキーを指定
  add_flash_types :success, :info, :warning, :danger
  # require_loginでログインされてないとされたとき実行
  #  (not_authenticated以外のメソッドを指定する場合、config/initializers/sorcery.rbを編集して変更)
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end
end
