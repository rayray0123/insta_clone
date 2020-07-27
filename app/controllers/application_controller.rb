class ApplicationController < ActionController::Base
  # ログインしていなかったらnot_authenticatedを実行
  before_action :require_login

  protected

  def not_authenticated
    redirect_to welcome_path
  end
end
