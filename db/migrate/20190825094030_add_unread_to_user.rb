class AddUnreadToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :unread, :integer, default: 0
  end
end
