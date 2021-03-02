class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :subject, polymorphic: true
      # t.referencesで belongs_to: user、 foreign_key: trueで 外部キー制約(user_id)をつける
      t.references :user, foreign_key: true
      t.integer :action_type, null: false
      t.boolean :read, null: false, default:false

      t.timestamps
    end
  end
end
