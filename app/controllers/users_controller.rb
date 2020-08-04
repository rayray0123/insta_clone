class UsersController < ApplicationController
# skip_before_action :require_login
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save # ユーザー登録できた場合
      auto_login(@user)
      redirect_to root_path, success: 'ユーザーを作成しました' #ルート画面に戻る
    else
      flash.now[:danger] = 'ユーザーに作成に失敗しました'
      render :new # ユーザー登録画面へ戻る
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username)
  end
end
