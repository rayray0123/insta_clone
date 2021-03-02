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
  # class_name = 一つのモデルに対して、二つのアソシエーション経路を組む場合に使用
  # users.idに外部キー制約をはっている
  # @relationship.followedのような形で、@relationshipに紐づいたuserレコードを取得することができる
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  # has_one = その宣言が行われているモデルのインスタンスが、
  #           他方のモデルのインスタンスを「まるごと含んでいる」または「所有している」ことを示す。
  # as: = ポリモーフィック関連を定義
  has_many :activity, as: :subject, dependent: :destroy
  # オブジェクトがDBに保存されるときにデータが空じゃないか検証
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # follower_idとfollowed_idの同じ組み合わせを二つ以上保存しない
  validates :follower_id, uniqueness: { scope: :followed_id }

  # modelに紐付くインスタンスがcreateされた直後に必ず、発火する
  after_create_commit :create_activities

  private

  def create_activities
    # subject: = 更新されたsubject_type（モデル）, 'subject_id（モデルのid） を指定
    # user: = フォローをされたuserのid（followedはrelationshipモデルに関連付けを定義）
    # action_type =
    Activity.create(subject: self, user: followed, action_type: :followed_me)
    # Activity Create (1.1ms)  INSERT INTO `activities` (`subject_type`, `subject_id`, `user_id`, `action_type`, `created_at`, `updated_at`)
    # VALUES ('Relationship', 47, 2, 2, '2021-02-15 13:53:22', '2021-02-15 13:53:22')
  end
end
