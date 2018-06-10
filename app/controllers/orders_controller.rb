class OrdersController < BaseFrontendController
  protect_from_forgery :except => [:apply]

  def show
    add_breadcrumb 'Order', ''

    @order = Order.find_by_guid! params[:guid]

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def apply
    # TODO return checking process of payment_status and return empty 200
    # instead of redirecting.
    #
    # IPN Simulator
    # https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNSimulator/

    logger.info "---===>>> Data from IPNSimulator ===--->"
    logger.debug params

    render nothing: true, status: :ok
    return

    order = nil


    # https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNIntro/
    # receiver_email - must be equal to business email
    # payer_email = gm_1231902590_per@paypal.com
    # payer_id = LPLWNMTBWMFAY
    # payer_status = verified
    # first_name = Test
    # last_name = User
    # address_city = San Jose
    # address_country = United States
    # address_state = CA
    # address_status = confirmed
    # address_country_code = US
    # address_name = Test User
    # address_street = 1 Main St
    # address_zip = 95131

    # It necessary to validate with:
    # https://ipnpb.paypal.com/cgi-bin/webscr?cmd=_notify-validate&mc_gross=19.95
    # &protection_eligibility=Eligible&address_status=confirmed&payer_id=LPLWNMTBWMFAY
    # &tax=0.00&address_street=1+Main+St&payment_date=20%3A12%3A59+Jan+13%2C+2009+PST
    # &payment_status=Completed&charset=windows-1252&address_zip=95131&first_name=Test
    # &mc_fee=0.88&address_country_code=US&address_name=Test+User&notify_version=2.6
    # &custom=&payer_status=verified&address_country=United+States&address_city=San+Jose&quantity=1&
    # verify_sign=AtkOfCXbDm2hu0ZELryHFjY-Vb7PAUvS6nMXgysbElEn9v-1XcmSoGtf&
    # payer_email=gpmac_1231902590_per%40paypal.com&txn_id=61E67681CH3238416&payment_type=instant
    # &last_name=User&address_state=CA&receiver_email=gpmac_1231902686_biz%40paypal.com
    # &payment_fee=0.88&receiver_id=S8XGHLYDW9T3S&txn_type=express_checkout&item_name=&mc_currency=USD
    # &item_number=&residence_country=US&test_ipn=1&handling_amount=0.00&transaction_subject=
    # &payment_gross=19.95&shipping=0.00
    #
    # Will get or VERIFIED or INVALID

    # 1. Check that the payment_status is Completed.
    # 2. If the payment_status is Completed, check the txn_id against the previous
    #    PayPal transaction that you processed to ensure the IPN message is not a duplicate.
    # 3. Check that the receiver_email is an email address registered in your PayPal account.
    # 4. Check that the price (carried in mc_gross) and the currency (carried in mc_currency)
    #    are correct for the item (carried in item_name or item_number).


    # if params[:payment_status] && params[:payment_status] == "Completed"
      a_cart = Cart.find_by_id params[:cart_id]
      if a_cart
        # logger.info "Processing cart #{a_cart.id}"
        # logger.debug params

        order = Order.create user: current_user
        a_cart.items.each do |item|
          order.items.create quantity: item.quantity,
                             price: item.ticket.price,
                             currency: item.ticket.currency,
                             ticket_id: item.ticket.id,
                             event_id: item.ticket.event.id,
                             event_name: item.ticket.event.name,
                             category: item.ticket.category,
                             pairs_only: item.ticket.pairs_only
        end
        a_cart.destroy
      end
    # end

    # render plain: 'ok'
    redirect_to order ? order_path(order.guid) : cart_path
  end
end
