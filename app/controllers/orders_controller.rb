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
    if allowed
      unless(params['receiver_email'].present? &&
             params['payment_status'].present? &&
             params['txn_id'].present?)
        allowed = false
        pay_logger.error 'Forbidden: Wrong params structure (no receiver_email, payment_status, txn_id).'
      end
    end

    # Check correct business email
    if allowed
      unless params['receiver_email'] == ENV.fetch('PAYPAL_BUSINESS_EMAIL')
        allowed = false
        pay_logger.error "Forbidden: Wrong receiver email. Needs #{ENV.fetch('PAYPAL_BUSINESS_EMAIL')}."
      end
    end

    # Check status is correct
    if allowed
      unless params['payment_status'] == "Completed"
        allowed = false
        pay_logger.error "Forbidden: Payment status is not Completed but #{params['payment_status']}."
      end
    end

    # Check that it's not a duplicate
    if allowed
      if Order.where(txn_id: params['txn_id']).any?
        allowed = false
        pay_logger.error "Forbidden: Already have order with txn_id = #{params['txn_id']}."
      end
    end

    # Check that this request is valid by rending it back to PayPal
    # skip for development
    if allowed && Rails.env != 'development'
      raw = request.raw_post
      sbstr = ENV.fetch('PAYPAL_SANDBOX_MODE') == '1' ? 'sandbox.' : '';
      uri = URI.parse("https://ipnpb.#{sbstr}paypal.com/cgi-bin/webscr?cmd=_notify-validate")
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 60
      http.read_timeout = 60
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.use_ssl = true
      response = http.post(
        uri.request_uri,
        raw,
        'Content-Length' => "#{raw.size}",
        'User-Agent' => "Ticketfinders-IPN-VerificationScript"
      ).body
      case response
      when "VERIFIED"
        # all ok in this case
      when "INVALID"
        allowed = false
        pay_logger.warn "Forbidden: PayPal's ipnpb mark this request as invalid."
      else
        allowed = false
        pay_logger.error "Forbidden: Error in PayPal's ipnpb check."
      end
    end

    items_to_process = []

    # Find and check all the items
    if allowed
      items_counter = 1
      while params["item_number#{items_counter}"]
        pay_logger.info "Check item ##{items_counter}: " +
                        "ID " + params["item_number#{items_counter}"] + ", " +
                        params["item_name#{items_counter}"]

        found_ticket = Ticket.find_by_id(params["item_number#{items_counter}"])

        unless found_ticket
          allowed = false
          pay_logger.error "Forbidden: Ticket with id " + params["item_number#{items_counter}"] + " can not be found"
          break
        end

        if found_ticket.enquire?
          allowed = false
          pay_logger.error "Forbidden: Ticket is only for enquire, not for sale"
          break
        end

        unless params['mc_currency'] == found_ticket.currency
          allowed = false
          pay_logger.error "Forbidden: Ticket currency not match with mc_currency: " +
                              "#{found_ticket.currency} vs #{params['mc_currency']}."
          break
        end

        quantity = params["quantity#{items_counter}"].to_i

        if found_ticket.quantity < quantity
          allowed = false
          pay_logger.error "Forbidden: Ticket quantity is not enough for ordering: " +
                              "#{found_ticket.quantity} < #{quantity}."
          break
        end

        gross = found_ticket.price * quantity + 15.0 # 15.0 it is shipping
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
    cart = Cart.find_by_id params[:cart_id]

    # Create order and add items to it
    if allowed && items_to_process.any?
      order = Order.create user: (cart ? cart.user : nil),
                           txn_id: params['txn_id'],
                           currency: params['mc_currency'],
                           shipping: params['mc_shipping'].to_f,
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
    if allowed && cart
      items_to_process.each do |item|
        found_item = cart.items.where(ticket_id: item.ticket_id).take
        found_item.destroy if found_item
      end
      unless cart.items.any?
        cart.destroy
      end
    end

    if allowed && order
      pay_logger.info "Order ##{order.id} was sucessfully created." +
        (order.user ? " User: (#{order.user.id}) #{order.user.email}" : '')
      message = OrdersMailer.order_created_message_to_user(order)
      message.deliver if message
    else
      pay_logger.error "Order wasn't created."
    end
    pay_logger.close

    render nothing: true, status: :ok

    # Parameters example:
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
