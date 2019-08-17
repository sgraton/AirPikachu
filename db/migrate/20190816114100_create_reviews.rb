class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.integer :star, default: 1
      t.references :room, null: false, foreign_key: true
      t.references :reservation, null: false, foreign_key: true
      t.references :guest, null: false, foreign_key: { to_table: :users }
      t.references :host, null: false, foreign_key: { to_table: :users }
      t.string :type

      t.timestamps
    end
  end
end
