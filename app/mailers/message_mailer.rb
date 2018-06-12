class MessageMailer < ApplicationMailer

  def send_email(message)
    @message = message
    mail(:to => recipients, :subject => "New contact form submission at ticket-finders.com")
  end

  def send_hospitality_concierge_email(client_email)
    @client_email = client_email
    mail(:to => recipients, :subject => "New Hospitality & Concierge services request at ticket-finders.com")
  end

  def send_ticket_enquiry(enquiry)
    @enquiry = enquiry
    mail(:to => recipients, :subject => "New ticket enquiry at ticket-finders.com")
  end

  private

  def recipients
    # ["john@ticket-finders.com", "info@ticket-finders.com"]
    ['mstrdymio@gmail.com']
  end

end
