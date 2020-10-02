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
  # User.find(2).commentsで、ユーザーの所有するコメントを取得できる。
  # ユーザーが削除されたときに、そのユーザーに紐付いた(そのユーザーが投稿した)投稿も一緒に削除
  has_many :comments, dependent: :destroy
  # has many = 多くを持つ
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy

  # クラスメソッド = クラスオブジェクトから呼び出すためのメソッド
  # インスタンスメソッド = インスタンスオブジェクトから呼び出すためのメソッド(own?)
  # ログインしている人の投稿だったらtrueを返す
  # current_user.idと投稿のuser_idを判定している
  def own?(object)
    # id = self.id
    id == object.user_id
  end
end
