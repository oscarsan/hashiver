class AddOriginToDeliveryOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :delivery_orders, :origin, :string
  end
end
