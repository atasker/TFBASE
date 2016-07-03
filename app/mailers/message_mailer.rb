class MessageMailer < ApplicationMailer

  def send_email(message)
    @message = message
    recipients = ["john@ticket-finders.com", "info@ticket-finders.com"]
    mail(:to => recipients, :subject => "New contact form submission at ticket-finders.com")
  end

end
