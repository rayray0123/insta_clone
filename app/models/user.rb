# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  # バリデーションは、正しいデータだけをデータベースに保存するために行われる
  # usernameが重複していないか、空じゃないか
  validates :username, uniqueness: true, presence: true
  # パスワードは３文字以上で objectがdatabaseに保存されていないとき(new_record?)かつ パスワードが更新された時(changes)
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  # パスワードが確認用パスワードと一致しいるかどうか
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  # 確認用パスワードが空じゃないか
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # e-mailが重複していないか、空じゃないか
  validates :email, uniqueness: true, presence: true

  # has_manyの第一引数に、そのモデルに紐づくモデル名を全て小文字で複数系で設定
  # ユーザーが削除されたときに、そのユーザーに紐付いた(そのユーザーが投稿した)投稿も一緒に削除
  has_many :posts, dependent: :destroy
  # User.find(2).commentsで、ユーザーの所有するコメントを取得できる。
  has_many :comments, dependent: :destroy
  # has_many　:like_postsより上に記述すること
  has_many :likes, dependent: :destroy
  # @user.like_postsとするとuserがlikeしたpostを取得できる
  # likeモデルのuser.idとpost.idの組み合わせを見てUserモデルをLikeモデルを経由してPostモデルと関連づける
  has_many :like_posts, through: :likes, source: :post

  # user対user（多対多）の関係性をアソシエーションで表現していく
  # user.followingをできるように、active_relationshipsを設定する。
  # 外部キーをfollower_idとして指定し、Relationshipモデルを取得する。
  # foreign_key = 外部キーをモデル名_id以外のカラムに指定したい場合,使用
  # class_name = 一つのモデルに対して、二つのアソシエーション経路を組む場合に使用
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  # user.followersをできるように、passive_relationshipsを設定する。
  # 外部キーをfollowed_idとして指定し、Relationshipモデルを取得する。
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  # userモデルのだれかから、最終的にfollow関係にあるuserモデルのだれかを参照する
  # source = 関連先テーブル名とアソシエーション名が異なる場合は、sourceオプションを使う
  # user.followingでfollower_idと対になるfollowed_idからそのuser'が'followをしているuserを全て取得する
  has_many :following, through: :active_relationships, source: :followed
  # user.followersでfollowed_idと対になるfollower_idからそのuser'を'followをしているuserを全て取得する
  has_many :followers, through: :passive_relationships, source: :follower

  # モデルのscope = 複数のクエリをまとめたメソッド
  # DBから新しい順にレコードをcountの数取り出す
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

  # クラスメソッド = クラスオブジェクトから呼び出すためのメソッド
  # インスタンスメソッド = インスタンスオブジェクトから呼び出すためのメソッド(own?)
  # ログインしている人の投稿だったらtrueを返す
  # current_user.idと投稿のuser_idを判定している
  def own?(object)
    # id = self.id
    id == object.user_id
  end

  def like(post)
    # << = has_manyを設定しているモデル(ここではPost)と新しく関連付けをする（has_manyを
    # 設定すると使えるようになるメソッド）
    # like_posts = self.like_posts
    # current_user.like_postsで得られる投稿(ログインユーザーがいいねした投稿)に、今いいねした投稿を追加。このときlikeテーブルに新しくレコードが作られる。
    like_posts << post
  end

  def unlike(post)
    # delete = has_manyを設定すると使えるようになるメソッド
    like_posts.delete(post)
  end

  def like?(post)
    # like_postsの中にpostオブジェクトが含まれていればtrueを返す。
    like_posts.include?(post)
  end

  # 新しいfolllowしている人(followed_id)、followされている人(follower_id)の組み合わせをrelationshipモデルに追加
  def follow(other_user)
    following << other_user
  end

  # アンフォローしたユーザーとされたユーザーを紐づけていたrelasionshipモデルのレコードを削除
  def unfollow(other_user)
    following.destroy(other_user)
  end

  # current_userがフォローしているユーザーの中にother_userが含まれていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # current_userがfollowしているuser.id、current_user自身の投稿をuser.idから投稿を取得
  # self.following_ids << self.id → current_userがfollowしているuserのidの配列に自身のuser.idを追加する
  def feed
    Post.where(user_id: following_ids << id)
  end
end
