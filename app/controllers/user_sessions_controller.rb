class UserSessionsController < ApplicationController
  def new; end

  def create
    # ユーザ名かメールアドレス、入力されたパスワード、remember_meチェックボックスの3つのパラメータをとる。
    # このメソッドが認証を行い、一致するものが見つかった場合にそのUserを返す。
    user = login(params[:email], params[:password])

    if user
      redirect_back_or_to posts_path, success: 'ログインしました'
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new # render → viewを直接表示
    end
  end

  def destroy
    logout
    redirect_to login_path, success: 'ログアウトしました' # redirect_to → 指定されたURLへ飛ぶ
  end
end
