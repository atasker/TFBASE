namespace :doafter do

  desc "Operation to do after deploy"
  task deploy: :environment do
    Ticket.where("currency <> '' AND currency IS NOT NULL").each do |ticket|
      ticket.currency = case ticket.currency
                        when 'Pounds' then 'GBP'
                        when 'Dollars' then 'USD'
                        when 'Euros' then 'EUR'
                        else ticket.currency
                        end
      ticket.currency = 'USD' if ticket.currency.empty? && !ticket.enquire?
      ticket.save
    end
  end

end
