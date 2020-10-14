class CommentsController < ApplicationController
  # remote: true なので html.erb ではなく js.erb が
  # このコントローラのアクションに伴ってレンダリング(対応したjsファイルが出力)される
  # 対応したjsファイルでも設定したインスタンス変数(@comment)を参照できる
  def create
    # ちゃんと user_id, body, post_id 指定して、コメントをインスタンス変数に代入できている
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def edit
    # _comment.html.slimから
    # params[:id]にはコメントのidが入る
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    binding.pry
    @comment.update(comment_update_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    # .merge = 投稿のページの post.id を引っ張ってきてパラメータに追加
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
