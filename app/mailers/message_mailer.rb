class MessageMailer < ApplicationMailer

  def send_email(message)
    @message = message
    @for_user = false
    @have_account = false
    mail(:to => recipients, :subject => "New contact form submission at ticket-finders.com")
  end

  def send_hospitality_concierge_email(client_email)
    @client_email = client_email
    @for_user = false
    @have_account = false
    mail(:to => recipients, :subject => "New Hospitality & Concierge services request at ticket-finders.com")
  end

  def send_ticket_enquiry(enquiry)
    @enquiry = enquiry
    @for_user = false
    @have_account = false
    mail(:to => recipients, :subject => "New ticket enquiry at ticket-finders.com")
  end

  def send_ticket_enquiry_to_client(enquiry)
    @enquiry = enquiry
    @have_account = false
    mail(:to => @enquiry.email, :subject => "New ticket enquiry at ticket-finders.com")
  end

  def acount_creation_confirmation(user)
    @user = user
    mail(:to => @user.email, :subject => "Welcome to ticket-finders.com")
  end

  private

  def recipients
    if Rails.env == 'production'
      ["john@ticket-finders.com", "info@ticket-finders.com"]
    else
      [ ENV['DEVELOPER_EMAIL'] ]
    end
  end

end
