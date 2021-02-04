class AddAvatarToUsers < ActiveRecord::Migration[5.2]
  # rails g migration AddAvatarToUsers avatar:string
  def change
    add_column :users, :avatar, :string
  end
end
