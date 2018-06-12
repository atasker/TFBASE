class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('GMAIL_USER', 'info@ticket-finders.com')
  layout 'mailer'
end
