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
  # テキスト型のカラムに配列を格納するための行
  serialize :images, JSON
  # ユーザーが削除されたときに、そのユーザーに紐付いた(そのユーザーが投稿した)投稿も一緒に削除,
  # ここにdependent: :destroyをつけると投稿が削除されたときにユーザーも削除されてしまう
  # belongs = 属する
  belongs_to :user
  # 投稿したユーザーが空じゃないか
  validates :user_id, presence: true
  # 投稿した文章が空じゃないか
  validates :body, presence: true, length: { maximum: 1000 }
  # 投稿した画像が空じゃないか
  validates :images, presence: true
end
