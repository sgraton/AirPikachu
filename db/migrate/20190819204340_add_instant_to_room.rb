class AddInstantToRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :instant, :integer, default: 1
  end
end
