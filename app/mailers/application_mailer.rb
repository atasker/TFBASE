class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAIL_FROM', 'info@ticket-finders.com')
  layout 'mailer'
  before_action :set_layout_variables

  protected

  def set_layout_variables
    @for_user = true
    @have_account = true
  end
end
