#################STAGE1##############################################

categories = ['Music', 'Opera', 'Theater', 'Concerts', 'Classical']
sports =     ['American Football', 'Baseball', 'Basketball', 'Boxing', 'Cricket', 'Football',
              'Golf', 'Hockey', 'Horse Racing', 'MMA', 'Motorcycling', 'Motor Racing', 'Olympics', 'Rugby',
              'Special Events', 'Tennis']
sports.each do |sport|
  Category.create(description: sport, sports: true)
end
categories.each do |category|
  Category.create(description: category, sports: false)
end
venues = ['Hammersmith Apollo', 'Fenway Park', 'TD Garden', 'London Palladium', 'Royal Albert Hall',
          'O2 Arena', 'Old Trafford', 'Emirates', 'Sydney Opera House', 'Paris Opera House']
venues.each do |venue|
  Venue.create(name: venue, capacity: rand(40000), city: 'Boston', country: 'USA', address: 'Boston, USA')
end

#####################################################################
################STAGE2###############################################

football_competitions = ['UEFA Cup', 'Premier League', 'FA Cup']
football_competitions.each do |comp|
  Competition.create(name: comp, category_id: Category.where(description: "Football").ids.pop)
end
opera_competitions = ['La Scala', 'Sydney Opera House']
opera_competitions.each do |opera_comp|
  Competition.create(name: opera_comp, category_id: Category.where(description: "Opera").ids.pop)
end

#####################################################################
###############STAGE3################################################

football_players = ['Arsenal', 'Manchester Utd', 'West Ham', 'Newcastle', 'Everton']
concerts_players = ['Madonna', 'U2', 'Kings of Leon', 'Enya', 'Kate Bush', 'Adele']
football_players.each do |player|
  Player.create(name: player, category_id: Category.where(description: "Football").ids.pop)
end
concerts_players.each do |singer|
  Player.create(name: singer, category_id: Category.where(description: "Concerts").ids.pop)
end

#####################################################################
##############STAGE4#################################################

matches = ["Arsenal vs Chelsea", "Manchester Utd vs Everton", "Newcastle vs West Ham"]
counter = 0

3.times do Event.create(
{
  name: matches[counter],
  start_time: rand(6.months).seconds.from_now,
  venue_id: Venue.limit(1).order("RANDOM()").ids.pop,
  category_id: Category.where(description: "Football").ids.pop,
  sports: true
})
counter += 1
end

concerts = ["U2 Live", "Kings of Leon", "Enya Live at the O2"]
inc = 0

3.times do Event.create(
{
  name: concerts[inc],
  start_time: rand(6.months).seconds.from_now,
  venue_id: Venue.limit(1).order("RANDOM()").ids.pop,
  category_id: Category.where(description: "Concerts").ids.pop,
  sports: false
})
inc += 1
end

#################PAGES##############################################
Page.create!([
  { title: 'Homepage',
    path: '/',
    seo_descr: 'Buy tickets to concerts, sports, arts, theater and hard ' \
               'to find sold out events worldwide.'
  },
  { title: 'About us',
    path: 'static/about',
    body: '<p>We at Ticketfinders International LLC have forty-four years '\
          'experience of the secondary ticket market.</p><p>Ticketfinders '\
          'International is a truly international ticket brokerage, specializing '\
          'in sourcing tickets throughout Europe and the World with particular '\
          'expertise in finding hard to get and sold out events. Whether for '\
          'personal or corporate clients, Ticketfinders International aims to '\
          'offer the best personalized experience for each one of our patrons, '\
          'with particular detail taken to find the very best tickets available '\
          'at the best possible price.</p>'
  },
  { title: 'Sport', path: 'static/sport' },
  { title: 'Terms & Conditions',
    path: 'static/terms',
    body: <<-EOS
<p>If you do not agree with the Terms &amp; Conditions, do not use this Website. If you do use the Website, your conduct indicates that you agree to be bound by the Terms and Conditions and also do not object to any content or information contained within this website.</p>
<ol>
<li>A <strong>contract</strong> shall be deemed to have been made between Ticketfinders International LLC and the booking client when the client has confirmed requirements by booking form, e-mail, letter or fax and Ticketfinders International LLC have accepted such booking.</li>
<li>For non credit card bookings, a non-refundable <strong>deposit</strong> of 100% of the overall cost of the booking together with 100% of any VAT must be paid within 7 days of the issue of the invoice.  If these time limits are not kept Ticketfinders International LLC reserve the right to cancel and re-allocate all bookings without informing the client.</li>
<li>
  a)  No changes, <strong>cancellations</strong> or refunds may be made to credit card or invoiced bookings once booking has been accepted by Ticketfinders International LLC. The cancellation of booked tickets is only possible when Ticketfinders International LLC has not yet processed your booking administratively. In these cases a cancellation is possible together with the charge of 40% of the sales price in the name of the cancellation expenses. As soon as Ticketfinders International LLC have forwarded your booking to the organiser or supplier, a cancellation is not possible any more. In this case Ticketfinders International LLC must charge the full sales price. In exceptional cases tickets (only fully paid ones) can be accepted by Ticketfinders International LLC for resale on commission basis. Ticketfinders International LLC can reimburse the costs only in the amount of the ticket price obtained by the resale, minus 40% commission fee. Ticketfinders International LLC reserves the right to decide if Ticketfinders International LLC can accept the tickets for resale on commission basis.<br>
  b)  If for any reason any event shall be cancelled or dates changed by the organizers  no refund will be made.<br>
  c)  Refunds will be made in full where appropriate.
</li>
<li>
  a)  In all arrangements involving third parties Ticketfinders International LLC act only as agent of the client and no <strong>liability</strong> of any kind whatsoever shall be attached to Ticketfinders International LLC in connection with or arising from such arrangement with a third party.<br>
  b)  Ticketfinders International LLC will not be responsible for loss, damage or injury to any person or their property, howsoever caused.<br>
  c)  Ticketfinders International LLC will not be responsible for failure of the Post Office or other delivery services employed to deliver on time. d)  Ticketfinders International LLC will not be responsible for lost or stolen items whilst in transit with the Post Office or other delivery services employed to deliver said items.<br>
  e)  Whilst every care is taken to ensure  tickets arrive on time at the agreed destination, in the event of failure to supply the tickets,  Ticketfinders International LLC's liability will extend only to a full refund of the price paid to us for the tickets.<br>
  f)  Ticketfinders International LLC  acts as an intermediary on your behalf with the actual suppliers of services. Although we will endeavour to pursue any claims to your satisfaction, our liability to you will be according to the supplier's policy and limited to the service and amount we invoiced.
</li>
<li>
  Every reasonable effort will be made to adhere to the advertised packages and events but any package may be <strong>altered or omitted or dates changed</strong> for any cause which Ticketfinders International LLC, at their absolute discretion, shall consider to be just and reasonable.<br>
  Ticketfinders International LLC have the right to change the prices in force at any time.  When such price is more than that advertised the difference must be paid before the tickets are issued.  If Ticketfinders International LLC increase prices or alter packages, the client shall be entitled to cancel the booking by giving written notice to be received by Ticketfinders International LLC within seven days of the announcement of the change.  In this event, the client shall be entitled to a full refund of any invoice or part invoice paid.
</li>
<li><strong>Extras:</strong> All accounts for service and goods provided at any event which are not covered by an inclusive package cost are due for payment within seven days of receipt of invoice.</li>
<li>All packages offered are subject to <strong>availability</strong>.</li>
<li><strong>Gift Vouchers</strong> not redeemable for cash.</li>
<li><strong>Complaints</strong> can be processed only if they are received in writing within 14 days after the event.</li>
<li>Our <strong>prices</strong> reflect the cost of obtaining preferred seating and are based on supply, demand and seat   location.  This is made up of the face value of the ticket plus costs incurred by us in locating tickets, booking fees, charges, taxes, management fees, commission and profit.  This can result in our prices being from 100% to 700%, or more, higher than the face value.</li>
<li>Ticketfinders International LLC is a Limited Liability Company incorporated in the State of Delaware, U.S.A., engaged in the services of finding and providing tickets for admission to any and all events. We are not affiliated with, nor do we have any licences or strategic alliances with, nor are we authorized by any League, team, association or venue. All and any copyrights, trademarks, or trade names used within this web site are for descriptive purposes only.</li>
<li>
  Regulated state and province list
  PayPal's ticket resale policy applies to events held in the following states and Canadian provinces (Underlined states have links to additional information):
  U.S. States
  <strong>Arkansas</strong>
  State law permits the resale of tickets by sellers in Arkansas at no greater than face value for all entertainment events held in the state. For tickets to Arkansas events sold by non-Arkansas residents, buyers within Arkansas may not purchase above face value.
  <strong>Connecticut</strong>
  State law permits the resale of tickets by sellers in Connecticut at no greater than face value plus $3 per ticket for all entertainment events held in the state. For tickets to Connecticut events sold by non-Connecticut residents, buyers within Connecticut may not purchase above face value plus $3.
  <strong>Florida</strong>
  State law permits the resale of tickets by sellers in Florida at no greater than face value plus $1 per ticket for all entertainment events held in the state. For tickets to Florida events sold by non-Florida residents, buyers within Florida may not purchase above face value plus $1. In addition, PayPal does not permit the sale of multi-day or multi-event tickets that have been used at least once for admission.
  <strong>Illinois</strong>
  State law permits resale of tickets by sellers in Illinois at no greater than face value for all entertainment events in the state. However, ticket brokers licensed in the State of Illinois are not covered by this rule and may accept any price for tickets provided that their Illinois registration number is clearly displayed to potential buyers.
  <strong>Kentucky</strong>
  State law permits the resale of tickets by sellers in Kentucky at no greater than face value for all entertainment events held in the state. For tickets to Kentucky events sold by non-Kentucky residents, buyers within Kentucky may not purchase above face value.
  <strong>Louisiana</strong>
  State law permits the resale of tickets by sellers in Louisiana at no greater than face value for all entertainment events held in the state. For tickets to Louisiana events sold by non-Louisiana residents, buyers within Louisiana may not purchase above face value.
  <strong>Massachusetts</strong>
  State law permits the resale of tickets by Massachusetts residents at no greater than face value plus $2 per ticket for all entertainment events held in the state. For tickets to Massachusetts events sold by non-Massachusetts residents, buyers within Massachusetts may not purchase above face value plus $2.
  <strong>Michigan</strong>
  State law permits the resale of tickets by sellers in Michigan at no greater than face value for all entertainment events held in the state. For tickets to Michigan events sold by non-Michigan residents, buyers within Michigan may not purchase above face value.
  <strong>Minnesota</strong>
  State law permits the resale of tickets by sellers in Minnesota at no greater than face value for all entertainment events held in the state. For tickets to Minnesota events sold by non-Minnesota residents, buyers within Minnesota may not purchase above face value.
  <strong>Mississippi</strong>
  State law permits the resale of tickets at no greater than face value by Mississippi residents for all entertainment events held on state owned property, and athletic contests at Mississippi colleges or Universities in the state. For tickets to these events sold by non-Mississippi residents, buyers within Mississippi may not purchase above face value. The resale of tickets to other events held in Mississippi are not restricted by this rule.
  <strong>Missouri</strong>
  State law permits the resale of tickets by Missouri residents at no greater than face value plus $3 per ticket for all sporting events held in the state. For tickets to Missouri sporting events sold by non-Missouri residents, buyers within Missouri may not purchase above face value plus $3. Tickets to other entertainment events in Missouri are not restricted by this rule.
  <strong>New Mexico</strong>
  State law permits the resale of tickets by New Mexico residents at no greater than face value for all college athletic events held in the state. For tickets to New Mexico college athletic events sold by non-New Mexico residents, buyers within New Mexico may not purchase above face value. The resale of tickets to other events held in New Mexico are not restricted by this rule.
  <strong>New York</strong>
  State law permits the resale of tickets by sellers in New York at no greater than face value plus $5 or 20% per ticket (whichever is greater) for all entertainment events held in the state. For tickets to New York events sold by non-New York residents, buyers within New York may not purchase above face value plus $5 or 20% per ticket.
  <strong>North Carolina</strong>
  State law permits the resale of tickets by North Carolina residents at no greater than face value plus $3 per ticket for all entertainment events held in the state. For tickets to North Carolina events sold by non-North Carolina residents, buyers within North Carolina may not purchase above face value plus $3.
  <strong>Pennsylvania</strong>
  State law permits the resale of tickets by sellers in Pennsylvania at no greater than face value plus $5 or 25%, (whichever is greater) for all entertainment events held in the state. For tickets to Pennsylvania events sold by non-Pennsylvania, buyers in Pennsylvania may not purchase above face value plus $5 or 25% per ticket.
  <strong>Rhode Island</strong>
  State law permits the resale of tickets by Rhode Island sellers at no greater than face value plus $3 per ticket or 10% of the ticketed price (whichever is greater) for all entertainment events held in the state. For tickets to Rhode Island events sold by non-Rhode Island sellers, buyers in Rhode Island may not purchase above face value plus $3 or 10% per ticket.
  <strong>South Carolina</strong>
  State law permits the resale of tickets by South Carolina residents at no greater than face value plus $1 for all athletic contests, sporting, entertainment and amusement events held in the state. For tickets to South Carolina events sold by non-South Carolina sellers, buyers in South Carolina may not purchase above face value plus $1 per ticket.
  <strong>Canadian Provinces</strong>
  Alberta
  Alberta law permits the resale of tickets at no greater than face value for all entertainment events held in Alberta, including events held in Calgary and Edmonton.
  Manitoba
  Manitoba law permits the resale of tickets at no greater than face value for all entertainment events held in Manitoba, including events held in Winnipeg.
  Ontario
  Ontario law permits the resale of tickets at no greater than face value for all entertainment events held in Ontario, including events held in Toronto, Windsor and Hamilton.
</li>
</ol>
EOS
  },
  { title: 'Categories', path: 'categories' },
  { title: 'Contacts us',
    path: 'messages/new',
    body: <<-EOS
<p>
  USA +1 240 764 4969<br>
  UK +44 20 7193 8557<br>
  <a href="mailto:Info@ticket-finders.com">Info@ticket-finders.com</a>
</p>
<p>
  <span style="text-decoration: underline;">Head Office</span><br>
  Ticketfinders International LLC<br>
  1013 Centre Road, Suite 403-A<br>
  Wilmington DE 19805, USA
</p>
EOS
  }
])
