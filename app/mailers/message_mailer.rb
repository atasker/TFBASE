class MessageMailer < ApplicationMailer

  def send_email(message)
    @message = message
    recipients = ["john@ticket-finders.com", "info@ticket-finders.com"]
    mail(:to => recipients, :subject => "New contact form submission at ticket-finders.com")
  end

  def send_hospitality_concierge_email(client_email)
    @client_email = client_email
    recipients = ["john@ticket-finders.com", "info@ticket-finders.com"]
    mail(:to => recipients, :subject => "New Hospitality & Concierge services request at ticket-finders.com")
  end

  def send_ticket_enquiry(enquiry)
    @enquiry = enquiry
    recipients = ["john@ticket-finders.com", "info@ticket-finders.com"]
    mail(:to => recipients, :subject => "New ticket enquiry at ticket-finders.com")
  end

end
