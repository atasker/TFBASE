class Admin::OrdersController < AdminController

  def index
    @orders = Order.all.order(id: :desc).page(params[:page]).per(100)
  end

  def show
    @order = Order.find(params[:id])
  end

end
