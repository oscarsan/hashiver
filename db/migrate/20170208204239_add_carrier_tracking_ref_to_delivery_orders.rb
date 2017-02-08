class AddCarrierTrackingRefToDeliveryOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :delivery_orders, :carrier_tracking_ref, :string
  end
end
