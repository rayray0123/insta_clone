class SorceryCore < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_column :users, :name, :string
    rename_column :users, :name, :username
    change_column_null :users, :username, false, 0
  end
end
