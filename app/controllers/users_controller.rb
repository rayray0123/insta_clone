class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to welcome_path # ユーザー登録できた場合
    else
      render :new # ユーザー登録画面へ戻る
    end
  end

  private

  def user_params
    # 受け取るパラメータ群をuserに(require)、 利用可能なパラメータ名を指定(permit)
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
    )
  end
end
