class AddMerchantIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :merchant_id, :string
  end
end
