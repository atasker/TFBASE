# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.ticket-finders.com"

SitemapGenerator::Sitemap.create do

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #

  statics_updated_at = Date.new 2017, 8, 5
  add '/static/sport', :lastmod => statics_updated_at, :priority => 0.7, :changefreq => 'monthly'
  add '/static/terms', :lastmod => statics_updated_at, :priority => 0.7, :changefreq => 'monthly'
  add '/static/about', :lastmod => statics_updated_at, :priority => 0.7, :changefreq => 'monthly'

  Event.actual.each do |event|
    add event_path(event), :lastmod => event.updated_at, :priority => 0.7, :changefreq => 'daily'
  end

  Category.find_each do |category|
    add category_path(category), :lastmod => category.updated_at, :priority => 0.7, :changefreq => 'daily'
  end

  Player.find_each do |player|
    add player_path(player), :lastmod => player.updated_at, :priority => 0.7, :changefreq => 'daily'
  end

  Competition.find_each do |competition|
    add competition_path(competition), :lastmod => competition.updated_at, :priority => 0.7, :changefreq => 'daily'

    competition_players = []
    competition.events.actual.each do |event|
      event.players.each do |player|
        competition_players << player unless competition_players.include?(player)
      end
    end
    competition_players.each do |player|
      add competition_player_path(player, compet: competition), :lastmod => player.updated_at, :priority => 0.7, :changefreq => 'daily'
    end
  end

end
