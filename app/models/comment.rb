# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  # defaultでbelongs_toの第一引数に、そのモデルに紐づくモデル名を全て小文字で単数系で設定
  belongs_to :user
  belongs_to :post
  
  # has_one = その宣言が行われているモデルのインスタンスが、
  #           他方のモデルのインスタンスを「まるごと含んでいる」または「所有している」ことを示す。
  # as: = ポリモーフィック関連を定義
  # activity.rb の belongs_to :subject, polymorphic: true と セットで設定する
  has_one :activity, as: :subject, dependent: :destroy

  validates :body, presence: true, length: { maximum: 1000 }

  # modelに紐付くインスタンスがcreateされた直後に必ず、発火する
  after_create_commit :create_activities

  private

  def create_activities
    # subject: self にあたるモデルによって保存されるsubject_type、subject_idが変わる
    Activity.create(subject: self, user: post.user, action_type: :commented_to_own_post)
  end
end
