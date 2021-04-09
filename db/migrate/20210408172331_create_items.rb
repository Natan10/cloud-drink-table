class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.integer :quantity, default: "0", null: false
      t.decimal :price_cents, default: "0.0", precision: 14, scale: 2
      t.references :consumer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
