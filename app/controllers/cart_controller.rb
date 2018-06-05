class CartController < BaseFrontendController
  before_filter :get_ticket, only: [:add, :sub, :remove]
  protect_from_forgery :except => [:apply]

  def show
    add_breadcrumb 'Cart', ''

    if @cart
      @cart = Cart.includes(items: { ticket: [:event] }).find(@cart.id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: cart_representor }
    end
  end

  def add
    create_new_cart! unless @cart

    found_item = @cart.items.where(ticket: @ticket).take
    found_item = @cart.items.build(ticket: @ticket) unless found_item

    found_item.quantity += @quantity
    if @ticket.quantity && found_item.quantity > @ticket.quantity
      found_item.quantity = @ticket.quantity
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
      found_item.quantity -= @quantity
      if found_item.quantity > 0
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

  def apply
    if params[:payment_status] && params[:payment_status] == "Completed"
      a_cart = Cart.find_by_id params[:cart_id]
      if a_cart
        logger.info "Processing cart #{a_cart.id}"
        logger.debug params
        # TODO make an order
      end
    end

    render plain: 'ok'
  end

  private

  def get_ticket
    @ticket = Ticket.find(params[:ticket])
    @quantity = params[:quantity] ? params[:quantity].to_i : 1
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
        quantity: item.quantity }
    end
    repr[:items_count] = items_count
    repr
  end
end
