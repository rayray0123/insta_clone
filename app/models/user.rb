# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  crypted_password :string
#  email            :string           not null
#  name             :string
#  salt             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  # バリデーションは、正しいデータだけをデータベースに保存するために行われる
  # パスワードは３文字以上で objectがdatabaseに保存されていないとき(new_record?)かつ changesがよく分からない
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  # パスワードが確認用パスワードと一致しいるかどうか
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  # 確認用パスワードが空じゃないか
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # e-mailが空じゃないか、重複指定ないか
  validates :email, presence: true, uniqueness: true
end
