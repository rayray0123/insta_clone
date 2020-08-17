class SorceryCore < ActiveRecord::Migration[5.2]
# 今のDBのカラムなどをschema.rbで確認
# rails db:migrate:status 実行したマイグレーションを表示
# rails db:rollback でDBが、最新のマイグレートがされる前の状態になる ( STEP=3 ステップ数指定可)
# change は change_columnと同じ操作？
# ロールバックして何もmigrateしてない状態でdb:migrateすると今ある全てのmaigrationファイル(db/migrate内)が上から実行される
# t.string :email, null: false, unique: true と書いてmigrateしてもunique: trueがつかない。なのでadd_index
# ロールバックはマイグレーションファイルを書き換える前にしないとエラーが出る
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
