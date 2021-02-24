class ActivitiesController < ApplicationController
  before_action :require_login, only: %i[read]
  # /activities/3/read にアクセスした時メソッド実行
  # 未読を既読にするメソッド
  def read
    # activityインスタンスを代入(通知一つ)
    activity = current_user.activities.find(params[:id])
    # 間違い → read! =　中身があればtrue、空なら例外を返す
    # enumのメソッド read！ = ステータスをreadにする
    # https://qiita.com/shizuma/items/d133b18f8093df1e9b70
    # if activity.unread? = 未読なら activity.read! を実行
    activity.read! if activity.unread?
    redirect_to activity.redirect_path
  end
end
