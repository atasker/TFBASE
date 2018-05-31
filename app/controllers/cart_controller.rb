class CartController < BaseFrontendController
  before_filter :get_ticket, only: [:add, :sub, :remove]
  def show
    add_breadcrumb 'Cart', ''

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: cart_representor }
    end
  end

  def add
    create_new_cart! unless @cart

    found_item = @cart.items.where(ticket: @ticket).take
    found_item = @cart.items.build(ticket: @ticket) unless found_item

    found_item.amount += @amount
    if @ticket.quantity && found_item.amount > @ticket.quantity
      found_item.amount = @ticket.quantity
    end
    found_item.save

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json { render json: cart_representor }
    end
  end

  def sub
    raise ActiveRecord::RecordNotFound, "Record not found" unless @cart

    if found_item = @cart.items.where(ticket: @ticket).take
      found_item.amount -= @amount
      if found_item.amount > 0
        found_item.save
      else
        found_item.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json { render json: cart_representor }
    end
  end

  def remove
    raise ActiveRecord::RecordNotFound, "Record not found" unless @cart
    @cart.items.where(ticket: @ticket).destroy_all

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json { render json: cart_representor }
    end
  end

  def clear
    raise ActiveRecord::RecordNotFound, "Record not found" unless @cart
    @cart.items.clear

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json { render json: { status: 'ok' } }
    end
  end

  private

  def get_ticket
    @ticket = Ticket.find(params[:ticket])
    @amount = params[:amount] ? params[:amount].to_i : 1
  end

  def create_new_cart!
    if user_signed_in?
      @cart = Cart.create user: current_user
    else
      @cart = Cart.create
      session[:cart] = @cart.id
    end
  end

  def cart_representor
    repr = { id: @cart.id, items: nil }
    items_count = 0
    repr[:items] = @cart.items.map do |item|
      items_count++
      { id: item.id,
        ticket: item.ticket_id,
        amount: item.amount }
    end
    repr[:items_count] = items_count
    repr
  end
end
