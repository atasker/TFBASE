class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAIL_FROM', 'info@ticket-finders.com')
  layout 'mailer'
end
