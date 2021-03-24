class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.decimal :total_account, default: 0.0 , null: false
      t.integer :status, default: 0, null: false
      t.text :description
      t.references :user, null: false

      t.timestamps
    end
  end
end
