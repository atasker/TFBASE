class OrdersController < BaseFrontendController
  protect_from_forgery :except => [:apply]

  def show
    add_breadcrumb 'Order', ''

    @order = Order.find_by_guid! params[:guid]

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def apply_by_cart_id_after_paypal_payment
    logger.info "---- ---- ---- APPLY WITH PAYPAL ---- ---- ----"
    logger.debug params

    # Got params:
    # {
    #   "payment_type"=>"instant",
    #   "payment_date"=>"Sun Jun 10 2018 22:42:20 GMT+0700 (+07)",
    #   "payment_status"=>"Completed",
    #   "payer_status"=>"verified",
    #   "first_name"=>"John",
    #   "last_name"=>"Smith",
    #   "payer_email"=>"buyer@paypalsandbox.com",
    #   "payer_id"=>"TESTBUYERID01",
    #   "address_name"=>"John Smith",
    #   "address_country"=>"United States",
    #   "address_country_code"=>"US",
    #   "address_zip"=>"95131",
    #   "address_state"=>"CA",
    #   "address_city"=>"San Jose",
    #   "address_street"=>"123 any street",
    #   "business"=>"seller@paypalsandbox.com",
    #   "receiver_email"=>"seller@paypalsandbox.com",
    #   "receiver_id"=>"seller@paypalsandbox.com",
    #   "residence_country"=>"US",
    #   "item_name1"=>"something",
    #   "item_number1"=>"AK-1234",
    #   "quantity"=>"1",
    #   "shipping"=>"3.04",
    #   "tax"=>"2.02",
    #   "mc_currency"=>"USD",
    #   "mc_fee"=>"0.44",
    #   "mc_gross"=>"12.34",
    #   "mc_gross_1"=>"12.34",
    #   "mc_handling"=>"2.06",
    #   "mc_handling1"=>"1.67",
    #   "mc_shipping"=>"3.02",
    #   "mc_shipping1"=>"1.02",
    #   "txn_type"=>"cart",
    #   "txn_id"=>"899327589",
    #   "notify_version"=>"2.4",
    #   "custom"=>"xyz123",
    #   "invoice"=>"abc1234",
    #   "test_ipn"=>"1",
    #   "verify_sign"=>"undefined",
    #   "controller"=>"orders",
    #   "action"=>"apply",
    #   "cart_id"=>"test"
    # }

    # https://developer.paypal.com/docs/classic/paypal-payments-standard/integration-guide/formbasics/
    # https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNIntro/
    # https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNSimulator/

    if (params['payment_status'] &&
        params['payment_status'] == "Completed" &&
        params['receiver_email'] &&
        params['receiver_email'] == ENV.fetch('PAYPAL_BUSINESS_EMAIL') &&
        params['txn_id'] &&
        Order.where(tnx_id: params['txn_id']).count == 0 &&
        (cart = Cart.find_by_id params[:cart_id]))
      # TODO validate with request like:
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
      # --> Will return or VERIFIED or INVALID

      # Check that all the items of order in the cart
      all_items_are_ok = true
      items_to_process = []
      items_counter = 1
      while params["item_number#{items_counter}"]
        found_item = cart.items.find_by_id(id: params["item_number#{items_counter}"])
        if found_item
          # TODO check price (carried in mc_gross) and the currency (carried in mc_currency)
          items_to_process << found_item
        else
          all_items_are_ok = false
        end
        break unless all_items_are_ok
        items_counter += 1
      end

      if all_items_are_ok && items_to_process.any?
        order = Order.create user: current_user,
                             txn_id: params['txn_id'],
                             first_name: params['first_name'],
                             last_name: params['last_name'],
                             email: params['payer_email'],
                             payer_paypal_id: params['payer_id'],
                             address_name: params['address_name'],
                             address_country: params['address_country'],
                             address_country_code: params['address_country_code'],
                             address_zip: params['address_zip'],
                             address_state: params['address_state'],
                             address_city: params['address_city'],
                             address_street: params['address_street']
        items_to_process.each do |item|
          order.items.create quantity: item.quantity,
                             price: item.ticket.price,
                             currency: item.ticket.currency,
                             ticket_id: item.ticket.id,
                             event_id: item.ticket.event.id,
                             event_name: item.ticket.event.name,
                             category: item.ticket.category,
                             pairs_only: item.ticket.pairs_only
          item.destroy
        end
        unless cart.items.any?
          cart.destroy
        end
      end
    end

    # TODO add txn_id field and index on it

    render nothing: true, status: :ok
  end
end
