class DeliveryOrdersController < ApplicationController

  def index
     @delivery_orders = DeliveryOrder.all
  end
end
