class DeliveryOrdersController < ApplicationController

  def index
     @delivery_orders = DeliveryOrder.all
  end

  def show
    @delivery_order = DeliveryOrder.find(params[:id])
  end

  def edit
    @delivery_order = DeliveryOrder.find(params[:id])
  end

  def update
    @delivery_order = DeliveryOrder.find(params[:id])

    if @delivery_order.update(delivery_order_params)
      @delivery_order.process_order
      @delivery_order.update_model
      redirect_to @delivery_order
    else
      render 'edit'
    end
  end

  private
    def delivery_order_params
      params.require(:delivery_order).permit(:state, :carrier_tracking_ref)
    end

end
