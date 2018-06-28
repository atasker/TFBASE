module Frontender
  extend ActiveSupport::Concern

  included do
    before_filter :collect_categories, :add_home_breadcrumb, :determine_cart
    helper_method :page_meta, :add_breadcrumb, :breadcrumbs
  end

  protected

  def page_meta
    unless @page_meta_carrier
      unless @page_meta
        @page_meta = OpenStruct.new(
          seo_descr: 'Buy tickets to concerts, sports, arts, theater and hard ' \
                     'to find sold out events worldwide.')
      end
      @page_meta_carrier = Seo::Basic.new @page_meta, false
    end
    @page_meta_carrier
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path)
    self.breadcrumbs << { name: name, path: path }
  end

  private

  def collect_categories
    @categories = Category.order('description ASC')
  end

  def add_home_breadcrumb
    add_breadcrumb 'Home', root_path
  end

  def determine_cart
    if user_signed_in?
      @cart = current_user.cart
    else
      @cart = session[:cart].present? ? Cart.find_by_id(session[:cart]) : nil
    end

    # Add items of a cart in session to user's cart.
    # It heplful when visitor fill a cart and then signed in (up) as user.
    if user_signed_in? && session[:cart].present?
      session_cart = Cart.find_by_id session[:cart]
      if session_cart && session_cart.user.nil?
        if @cart
          merge_carts(session_cart, @cart)
        else
          session_cart.user = current_user
          session_cart.save
          @cart = session_cart
        end
      end
      session[:cart] = nil
    end

  end

  # Merge one cart to another one and destroy it after.
  # Move cart items with tickets which only in source cart and upgrade quantity
  # of target cart items of matching tickets.
  # @param from_cart [Cart] Source cart, which items should be added to target cart
  # @param to_cart   [Cart] Target cart to add items from source cart
  def merge_carts(from_cart, to_cart)
    cart_item_ids_to_move = []

    from_cart.items.each do |from_cart_item|
      cart_item = to_cart.items.where(ticket_id: from_cart_item.ticket_id).take
      if cart_item
        # when we have cart item with the same ticket just use the beggest quantity
        cart_item.quantity = [cart_item.quantity, from_cart_item.quantity].max
        cart_item.save
      else
        # when session cart has new for user's cart ticket, mark it to move in cart later
        cart_item_ids_to_move << from_cart_item.id
      end
    end

    CartItem.where(id: cart_item_ids_to_move).each do |cart_item|
      cart_item.cart = to_cart
      cart_item.save
    end if cart_item_ids_to_move.any?

    # if just from_cart.destroy all moved items will be destroyed too so
    Cart.where(id: from_cart.id).destroy_all
  end
end
