class AddIndexToTweets < ActiveRecord::Migration[5.0]
  def change
    add_index :tweets, :user_id
    add_index :tweets, :created_at
  end
end
