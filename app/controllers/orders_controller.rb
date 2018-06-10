class OrdersController < BaseFrontendController
  protect_from_forgery :except => [:apply_by_cart_id_after_paypal_payment]

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

    # {
    #   "txn_id"=>"70U68678SU8656119",
    #   "txn_type"=>"cart",
    #   "business"=>"mstrdymio-uk-business@gmail.com",
    #   "receiver_email"=>"mstrdymio-uk-business@gmail.com",
    #   "receiver_id"=>"KGJWP98ZPHPL4",
    #
    #   "payment_status"=>"Pending",
    #   "pending_reason"=>"multi_currency",
    #   "payment_date"=>"12:42:43 Jun 10, 2018 PDT",
    #   "payment_type"=>"instant",
    #   "payment_gross"=>"2360.00",
    #
    #   "mc_currency"=>"USD",
    #   "mc_gross"=>"2360.00",
    #   "mc_shipping"=>"30.00",
    #   "num_cart_items"=>"2",
    #
    #   "item_number1"=>"6401",
    #   "item_name1"=>"Ticket Messa di Gloria (category: Category Gold)",
    #   "quantity1"=>"2",
    #   "mc_shipping1"=>"15.00",
    #   "mc_gross_1"=>"885.00",
    #   "option_selection1_1"=>"N/A",
    #   "option_name1_1"=>"Category Gold",
    #
    #   "item_number2"=>"6402",
    #   "item_name2"=>"Ticket Messa di Gloria (category: Sector 1)",
    #   "quantity2"=>"4",
    #   "mc_shipping2"=>"15.00",
    #   "mc_gross_2"=>"1475.00",
    #   "option_selection1_2"=>"N/A",
    #   "option_name1_2"=>"Sector 1",
    #
    #   "payer_id"=>"6H9NA45EZD9GE",
    #   "payer_email"=>"mstrdymio-buyer@gmail.com",
    #   "payer_status"=>"verified",
    #   "first_name"=>"test",
    #   "last_name"=>"buyer",
    #
    #   "address_country_code"=>"RU",
    #   "address_name"=>"buyer test",
    #   "address_country"=>"Russia",
    #   "address_state"=>"\xD0\u001Aосква",
    #   "address_status"=>"confirmed",
    #   "address_street"=>"\xD1\u001Aли\xD1\u001Aа \xD0\u001Aе\xD1\u001Aвая, дом 1, ква\xD1\u001A\xD1\u001Aи\xD1\u001Aа 2",
    #   "address_zip"=>"127001",
    #   "address_city"=>"\xD0\u001Aосква",
    #
    #   "protection_eligibility"=>"Eligible",
    #   "charset"=>"windows-1252",
    #   "notify_version"=>"3.9",
    #   "custom"=>"",
    #   "verify_sign"=>"ASsJ54wcfEJZVuwOMU8vBNHZb1TpA2Nrttt7LMhvitNIW.grobXa7WDi",
    #   "residence_country"=>"RU",
    #   "test_ipn"=>"1",
    #   "transaction_subject"=>"",
    #   "ipn_track_id"=>"55b8d1156998",
    #
    #   "controller"=>"orders",
    #   "action"=>"apply_by_cart_id_after_paypal_payment",
    #   "cart_id"=>"6"
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
