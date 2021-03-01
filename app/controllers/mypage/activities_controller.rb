class Mypage::ActivitiesController < Mypage::BaseController
  # /mypage/activities にアクセスした時メソッド実行
  # 通知の内容の取得
  def index
    @activities = current_user.activities.order(created_at: :desc).page(params[:page]).per(10)
  end
end
