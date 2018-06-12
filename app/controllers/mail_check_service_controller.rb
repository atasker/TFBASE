class MailCheckServiceController < BaseFrontendController
  include SendGrid

  before_filter :uhfrkvbzslzbvlyrtbselr, except: [:hospitality_concierge]

  def new
    # render new.html.erb
  end

  def create
    @email_to = params[:email]
    @success = false
    @mail_response = nil

    # sending
    if @email_to.present?
      logger.info "Starting mail checking thru SendGrid.."
      from = Email.new(email: ENV.fetch('MAIL_FROM', 'info@ticket-finders.com'))
      to = Email.new(email: @email_to)
      subject = 'Ticketfinders mail check service test'
      content = Content.new(type: 'text/plain', value: 'This is just test email from Ticketfinders')
      mail = Mail.new(from, subject, to, content)

      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      @mail_response = sg.client.mail._('send').post(request_body: mail.to_json)
      @success = true
      logger.info "Mail is sent. There is a response:"
      logger.debug @mail_response
    end
    # end

    flash.now[:notice] = "Message sent!"
    render 'new'
  end

  private

  def uhfrkvbzslzbvlyrtbselr
    add_breadcrumb 'Email check service', nil
  end

end
