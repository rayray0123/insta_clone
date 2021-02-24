# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  # defaultでbelongs_toの第一引数に、そのモデルに紐づくモデル名を全て小文字で単数系で設定
  # belongs_toで多対１
  belongs_to :user
  belongs_to :post
  
  # has_one = その宣言が行われているモデルのインスタンスが、
  #           他方のモデルのインスタンスを「まるごと含んでいる」または「所有している」ことを示す。
  # as: = ポリモーフィック関連を定義
  has_one :activity, as: :subject, dependent: :destroy
  # user_id_とpost_idの組み合わせが同じものは一つだけに制限。いいねを2回させない。
  # scope: = 一意性チェックの範囲を限定する別の属性を指定する
  validates :user_id, uniqueness: { scope: :post_id }
  # modelに紐付くインスタンスがcreateされた直後に必ず、発火する
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(subject: self, user: post.user, action_type: :liked_to_own_post)
  end
end
