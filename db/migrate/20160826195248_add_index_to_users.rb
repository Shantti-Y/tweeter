class AddIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :email_num, unique: true
  end
end
