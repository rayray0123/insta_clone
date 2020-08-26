# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  body       :text             not null
#  images     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
class Post < ApplicationRecord
  # PostモデルにCarrierwaveを関連付け
  mount_uploader :image, PostImageUploader
  # テキスト型のカラムに配列を格納するための行
  serialize :images, JSON
  # ユーザーが削除されたときに、そのユーザーに紐付いた(そのユーザーが投稿した)投稿も一緒に削除
  belongs_to :user, dependent: :destroy
  # 投稿したユーザーが空じゃないか
  validates :user_id, presence: true
  # 投稿した文章が空じゃないか
  validates :body, presence: true, length: { maximum: 1000 }
  # 投稿した画像が空じゃないか
  validates :image, presence: true
end
