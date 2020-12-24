# Form Object = フォーム専用の特別な処理をモデルに書きたくない場合に用いる
class SearchPostsForm
  # ActiveModel::Model = https://railsguides.jp/active_model_basics.html
  include ActiveModel::Model
  include ActiveModel::Attributes
  # SearchPostsFormクラスで属性が使えるように定義する
  attribute :body, :string
  attribute :comment_body, :string

  def search
    # 全ての投稿を、本文が一致しているデータは除外して取得する
    scope = Post.distinct
    # 本文を検索して代入
    # scope.where('body LIKE ?', "%#{こんにちは^^}%")
    scope = scope.body_contain(body) if body.present?
    # 戻り値
    scope
  end
end
