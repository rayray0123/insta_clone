# Form Object = フォーム専用の特別な処理をモデルに書きたくない場合に用いる
class SearchPostsForm
  # ActiveModel::Model = https://railsguides.jp/active_model_basics.html
  include ActiveModel::Model
  include ActiveModel::Attributes
  # SearchPostsFormクラスで属性が使えるように定義する
  attribute :body, :string
  attribute :comment_body, :string
  attribute :username, :string

  def search
    # 全ての投稿を、一致しているものは除外して取得する
    scope = Post.distinct
    # @search_form.body.strip.split(/[[:blank:]]+/).map
    # map = 各要素へ順に処理を実行してくれるメソッド
    # 使い方： 配列変数.map {|変数名| 具体的な処理 }
    # 実際のmapの処理 = 分割した文字の配列から要素を一つづつ本文検索（戻り値も配列）
    # inject = eachとは違う記述で繰り返し処理を行うメソッド
    # 使い方 = 配列.inject {|結果, 要素| ブロック処理 }
    # 1番目と2番目の要素をブロック処理、実行結果と3番目の要素をブロック処理、・・・
    # 実際のinjectの処理 = 検索したい文字が含まれる投稿（配列）をまとめて、OR検索する
    if body.present?
      scope = splited_bodies.map { |splited_body| scope.body_contain(splited_body) }.inject { |result, scp| result.or(scp) }
    end
    # postsテーブルとcommentsテーブルを内部結合させている(joins)
    # よって入力されたキーワードが含まれるコメントがある投稿を検索
    scope = scope.comment_body_contain(body) if comment_body.present?
    # 同じ仕組みで、入力された文字が含まれるユーザー(名)の投稿を検索
    scope = scope.username_contain(username) if username.present?
    # 戻り値(postインスタンス)
    scope
  end

  private

  def splited_bodies
    # strip = 文字列の先頭と末尾にある空白を除去した文字列を生成して返してくれるStringクラスのメソッド
    # split = 文字列を分割して配列にするためのメソッド
    # /[[:blank:]]+/ = splitの区切り文字の中に、全角スペースを追加し、連続した全角スペースは削除する
    # https://qiita.com/nao58/items/bf5d017a06fc33da9e3b
    body.strip.split(/[[:blank:]]+/)
  end
end
