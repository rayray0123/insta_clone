class ApplicationController < ActionController::Base
  # ログインしていなかったらnot_authenticatedを実行
  # before_action :require_login
  add_flash_types :success, :info, :warning, :danger
end
