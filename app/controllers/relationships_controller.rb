class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  # _follow.html.slimのリンクからルーティング判断、createメソッド実行
  def create
    # followしたいuserのidをparamsで取得
    @user = User.find(params[:followed_id])
    # フォローの通知メールを送信
    UserMailer.with(user_from: current_user, user_to: @user).follow.deliver_later if current_user.follow(@user)
  end

  def destroy
    # followedはRelationshipモデルで定義したメソッド
    # × followed_idからそれと対をなすfollower_idに紐づくuserを取得して代入
    # ○ current_userのアンフォローしたいuserを取得し代入
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
