# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  crypted_password :string
#  email            :string           not null
#  salt             :string
#  username         :string           not null
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
end
