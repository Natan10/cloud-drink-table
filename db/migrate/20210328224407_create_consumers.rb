class CreateConsumers < ActiveRecord::Migration[6.1]
  def change
    create_table :consumers do |t|
      t.string :name, null: false
      t.decimal :total_consumed, default: "0.0", null: false
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
