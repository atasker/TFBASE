class OrdersController < BaseFrontendController
  protect_from_forgery :except => [:apply_by_cart_id_after_paypal_payment]

  def show
    add_breadcrumb 'Order', ''

    @order = Order.find_by_guid! params[:guid]

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # Create new order after Paypal notification.
  # There are usefull links to understand Paypal notification and how to work with:
  # https://developer.paypal.com/docs/classic/paypal-payments-standard/integration-guide/formbasics/
  # https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNIntro/
  # https://github.com/paypal/ipn-code-samples/blob/master/ruby/paypal_ipn_rails.rb
  # https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNSimulator/
  def apply_by_cart_id_after_paypal_payment
    pay_logger = Logger.new Rails.root.join('log', 'payments.log')
    pay_logger.info ''
    pay_logger.info "Started applying an order by Paypal payment."
    pay_logger.info Time.now.utc
    pay_logger.info 'Parameters:'
    pay_logger.debug params

    allowed = true

    # Check necessary parameters
    unless(allowed &&
           params['receiver_email'].present? &&
           params['payment_status'].present? &&
           params['txn_id'].present?)
      allowed = false
      pay_logger.error 'Forbidden: Wrong params structure (no receiver_email, payment_status, txn_id).'
    end

    # Check correct business email
    unless allowed && params['receiver_email'] == ENV.fetch('PAYPAL_BUSINESS_EMAIL')
      allowed = false
      pay_logger.error "Forbidden: Wrong receiver email. Needs #{ENV.fetch('PAYPAL_BUSINESS_EMAIL')}."
    end

    # Check status is correct
    unless allowed && params['payment_status'] == "Completed"
      allowed = false
      pay_logger.error "Forbidden: Payment status is not Completed but #{params['payment_status']}."
    end

    # Check that it's not a duplicate
    unless allowed && Order.where(tnx_id: params['txn_id']).count == 0
      allowed = false
      pay_logger.error "Forbidden: Already have order with txn_id = #{params['txn_id']}."
    end

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

    items_to_process = []

    # Find and check all the items
    if allowed
      items_counter = 1
      while params["item_number#{items_counter}"]
        pay_logger.info "Check item ##{items_counter}: " +
                        "ID " + params["item_number#{items_counter}"] + ", " +
                        params["item_name#{items_counter}"]
        found_ticket = Ticket.find_by_id(id: params["item_number#{items_counter}"])

        unless found_ticket
          allowed = false
          pay_logger.error "Forbidden: Ticket with id " + params["item_number#{items_counter}"] + " can not be found"
          break
        end

        # TODO check currency match
        # unless params['mc_currency'] == found_ticket.currency

        quantity = params["quantity#{items_counter}"]).to_i
        gross = found_ticket.price * quantity
        if gross != params["mc_gross_#{items_counter}"].to_f
          allowed = false
          pay_logger.error "Forbidden: Ticket gross not match with mc_gross: #{gross} " +
                                      "vs #{params["mc_gross_#{items_counter}"].to_f}."
          break
        end

        new_item = OrderItem.new quantity: quantity
        new_item.fill_by_ticket found_ticket
        items_to_process << new_item

        break unless allowed
        items_counter += 1
      end
    end

    order = nil

    # Create order and add items to it
    if allowed && items_to_process.any?
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

      if order.persisted? && order.valid?
        items_to_process.each do |item|
          item.order = order
          item.save
        end
      else
        allowed = false
        pay_logger.error "Forbidden: Error while create an order"
        pay_logger.debug order.errors.messages
      end
    end

    # Remove added to order tickets from the cart
    if allowed
      if cart = Cart.find_by_id params[:cart_id]
        order.items.each do |item|
          found_item = cart.items.where(id: item.ticket_id).take
          found_item.destroy if found_item
        end
        unless cart.items.any?
          cart.destroy
        end
      end
    end

    if allowed && order
      pay_logger.info "Order ##{order.id} was sucessfully created." +
        (order.user ? " User (#{order.user.id})#{order.user.email}" : '')
    else
      pay_logger.error "Order wasn't created."
    end
    pay_logger.close

    render nothing: true, status: :ok

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
  end
end
