# == Schema Information
#
# コメント、フォロー、いいね、この3つのアクティヴィティの情報が格納され、activitiesとuserは1対多の関係。
# Table name: activities
#
#  id           :bigint           not null, primary key
#  action_type  :integer          not null
#  read         :boolean          default("unread"), not null
#  subject_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ↓like、comment、postのいずれかのモデルのidが入る
#  subject_id   :bigint
#  ↓通知を受け取るユーザーのid
#  user_id      :bigint
#
# Indexes
#
#  index_activities_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_activities_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord
  # Url HelperはController、HelperとViewでしか使えないので、クラスでredirect_pathを使用できるようにしている
  include Rails.application.routes.url_helpers
  # ポリモーフィックをsubjectという名前で設定
  # ポリモーフィックを使わないと
  belongs_to :subject, polymorphic: true
  belongs_to :user
  # _header_activities.html.slim で使用するscope
  scope :recent, ->(count) { order(created_at: :desc).limit(count)}

  # action_typeによって
  # enum = １つのカラムに指定した複数個の定数を保存できる様にする為のモノ
  # 投稿へのコメントか、投稿へのいいねか、ユーザーへのフォローか判別
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
  # 既読、未読の判別
  enum read: { unread: false, read: true }

  # activity_controllerで使用するメソッド
  def redirect_path
    # to_sym = 文字列オブジェクトをシンボルに変換するメソッドのこと
    #          （action_typeが 2 だと、followed_me:に変換）
    case self.action_type.to_sym
    when :commented_to_own_post
      # 通知にされた投稿へリダイレクト
      post_path(subject.post, anchor: "comment-#{subject.id}")
    when :liked_to_own_post
      # いいねされた投稿へリダイレクト
      post_path(subject.post)
    when :followed_me
      # フォローされたユーザーの詳細ページへリダイレクト
      user_path(subject.follower)
    end
  end
end
