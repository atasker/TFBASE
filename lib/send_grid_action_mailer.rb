require 'fileutils'
require 'tmpdir'

module SendGridActionMailer
  class DeliveryMethod
    attr_reader :sg

    def initialize(params)
      @sg = SendGrid::API.new(api_key: params[:api_key])
    end

    def deliver!(mail)
      attachment_temp_dirs = []
      from = mail[:from].addrs.first

      # m.to        = mail[:to].addresses
      # m.cc        = mail[:cc].addresses  if mail[:cc]
      # m.bcc       = mail[:bcc].addresses if mail[:bcc]
      # m.from      = from.address
      # m.from_name = from.display_name
      # m.reply_to  = mail[:reply_to].addresses.first if mail[:reply_to]
      # m.date      = mail[:date].to_s if mail[:date]
      # m.subject   = mail.subject

      content = Content.new(type: 'text/plain', value: 'Error')

      case mail.mime_type
      when 'text/plain'
        content = Content.new(type: 'text/plain', value: mail.body.decoded)
      when 'text/html'
        content = Content.new(type: 'text/html', value: mail.body.decoded)
      when 'multipart/alternative', 'multipart/mixed', 'multipart/related'
        if mail.html_part
          content = Content.new(type: 'text/html', value: mail.html_part.decoded)
        elsif mail.text_part
          content = Content.new(type: 'text/plain', value: mail.text_part.decoded)
        end

        # mail.attachments.each do |a|
        #   # Write the attachment into a temporary location, since sendgrid-ruby
        #   # expects to deal with files.
        #   #
        #   # We write to a temporary directory (instead of a tempfile) and then
        #   # use the original filename inside there, since sendgrid-ruby's
        #   # add_content method pulls the filename from the path (so tempfiles
        #   # would lead to random filenames).
        #   temp_dir = Dir.mktmpdir('sendgrid-actionmailer')
        #   attachment_temp_dirs << temp_dir
        #   temp_path = File.join(temp_dir, a.filename)
        #   File.open(temp_path, 'wb') do |file|
        #     file.write(a.read)
        #   end

        #   if(mail.mime_type == 'multipart/related' && a.header[:content_id])
        #     email.add_content(temp_path, a.header[:content_id].field.content_id)
        #   else
        #     email.add_attachment(temp_path, a.filename)
        #   end
        # end
      end

      sg_mail = SendGrid::Mail.new(from, mail.subject, mail[:to].addresses, content)
      mail_response = @sg.client.mail._('send').post(request_body: sg_mail.to_json)
    # ensure
    #   # Close and delete the attachment tempfiles after the e-mail has been
    #   # sent.
    #   attachment_temp_dirs.each do |dir|
    #     FileUtils.remove_entry_secure(dir)
    #   end
    end
  end

  class Railtie < Rails::Railtie
    initializer 'sendgrid_actionmailer.add_delivery_method', before: 'action_mailer.set_configs' do
      ActionMailer::Base.add_delivery_method(:sendgrid_actionmailer, SendGridActionMailer::DeliveryMethod)
    end
  end
end
