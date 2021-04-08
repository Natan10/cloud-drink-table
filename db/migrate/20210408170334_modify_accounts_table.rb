class ModifyAccountsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :accounts, :total_account
    add_column :accounts, :total_account_cents,:decimal,default: "0.0", precision: 14, scale: 2
  end
end
