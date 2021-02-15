# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  # PostモデルにCarrierwaveを関連付け
  mount_uploaders :images, PostImageUploader
  # MySQL5.7からならカラムを作る時点でJASON型にすればいい
  # 配列で送られてきた画像データをDBにはただの一つの文字列(string型)として保存
  # 画像をDBから取り出すときその文字列を配列だと認識させるためにserialize,JASONを使う
  serialize :images, JSON
  # 投稿が削除されたときに、その投稿に紐付いたコメントも一緒に削除,
  # ここに belongs_to :user, dependent: :destroyをつけると投稿が削除されたときにユーザーも削除されてしまう
  # Post.find(20).commentsで、投稿に対するコメントを取得できる。
  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  # @post.like_usersとするとpostにlikeしているuserを取得できる
  # PostモデルをLikeモデルを経由してUserモデルと関連づける
  has_many :like_users, through: :likes, source: :user
  has_one :activity, as: :subject, dependent: :destroy
  # belongs = 属する
  belongs_to :user
  # 投稿した文章が空じゃないか
  validates :body, presence: true, length: { maximum: 1000 }
  # 投稿した画像が空じゃないか
  validates :images, presence: true
  # wordが含まれる投稿を取得
  # -> = lambda(変数に代入できる関数をその場で生成する構文の略記法)
  # ? = プレースホルダ(クエリに変数を書ける、SQLインジェクション対策になる)
  # https://railsguides.jp/security.html#sqlインジェクション
  scope :body_contain, ->(word) { where('body LIKE ?', "%#{word}%") }
  # postテーブルをベースにcommentsテーブルを結合
  scope :comment_body_contain, ->(word) { joins(:comments).where('comments.body LIKE ?', "%#{word}%") }
  scope :username_contain, ->(word) { joins(:users).where('username LIKE ?', "%#{word}%") }
end
