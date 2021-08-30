class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name,null: false
      t.string :description
      t.decimal :price_cents, precision: 14, scale: 2, default: "0.0"
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
