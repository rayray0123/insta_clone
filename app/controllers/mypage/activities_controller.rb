class Mypage::ActivitiesController < Mypage::BaseController
  before_action :require_login, only: %i[index]
  # /mypage/activities にアクセスした時メソッド実行
  # 通知の内容の取得
  def index
    @activities = current_user.activities.order(created_at: :desc).page(params[:page]).per(10)
  end
end
