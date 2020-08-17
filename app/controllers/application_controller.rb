class ApplicationController < ActionController::Base
  # bootstrapでフラッシュメッセージを表示できるようにキーを指定
  add_flash_types :success, :info, :warning, :danger
end
