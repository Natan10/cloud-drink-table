class ModifyConsumerTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :consumers, :total_consumed
    add_column :consumers, :total_consumed_cents,:decimal,default: "0.0", precision: 14, scale: 2
  end
end
