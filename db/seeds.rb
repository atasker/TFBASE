#################STAGE1##############################################

categories = ['Music', 'Opera', 'Theater', 'Concerts']
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
