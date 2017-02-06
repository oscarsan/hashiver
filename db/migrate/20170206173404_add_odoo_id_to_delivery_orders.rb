class AddOdooIdToDeliveryOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :delivery_orders, :odoo_id, :integer
  end
end
