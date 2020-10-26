# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :bigint           not null
#  follower_id :bigint           not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (followed_id => users.id)
#  fk_rails_...  (follower_id => users.id)
#
class Relationship < ApplicationRecord
  # @relationship.followerのような形で、@relationshipに紐づいたuserレコードを取得することができる
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  # オブジェクトがDBに保存されるときにデータが空じゃないか検証
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # follower_idとfollowed_idの同じ組み合わせを二つ以上保存しない
  validates :follower_id, uniqueness: { scope: :followed_id }
end
