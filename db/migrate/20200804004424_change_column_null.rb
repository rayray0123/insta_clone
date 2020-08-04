class ChangeColumnNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :username, false, 0
  end
end
