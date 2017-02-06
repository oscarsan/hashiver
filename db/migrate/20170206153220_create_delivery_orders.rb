class CreateDeliveryOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :delivery_orders do |t|
      t.string :name
      t.string :state
      t.string :display_name
      t.string :pack_operation_ids

      t.timestamps
    end
  end
end
