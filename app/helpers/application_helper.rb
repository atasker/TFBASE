module ApplicationHelper

  def nice_time(time)
    time.strftime("%a %d %B %H:%M")
  end

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename).source.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    if options[:class].present?
      svg["class"] = options[:class]
    end
    raw doc
  end

  def has_icon?(category)
    @stripped = category.gsub(/\s+/, '')
    if Rails.application.assets.find_asset("#{@stripped}Blue.svg") && Rails.application.assets.find_asset("#{@stripped}Grey.svg")
      return @stripped
    else
      return false
    end
  end

  def title(text)
    content_for :title, text
  end

  def gon(text)
    content_for :gon, text
  end

  def description(text)
    content_for :description, text
  end

  def recommended(master)
    city = master.venue.city
    target_events = []
    target_venues = []
    all_venues = Venue.all
    all_venues.each do |venue|
      if venue.city == city
        target_venues << venue
      end
    end
    target_venues.each do |venue|
      venue.events.actual.each do |event|
        target_events << event unless event == master
      end
    end
    if target_events.count > 1
      if target_events.count > 6
        sorted = target_events.sort { |a,b| a.start_time <=> b.start_time }
        return sorted.take(6)
      end
      sorted = target_events.sort { |a,b| a.start_time <=> b.start_time }
      return sorted
    else
      random_events = Event.all.sample(6)
      sorted = random_events.sort { |a,b| a.start_time <=> b.start_time }
      return sorted
    end
  end

  # Method returns svg code of category icon if available, else empty string
  # Params:
  #   category — object of Category class
  def category_icon(category)
    key = category.description.to_s.parameterize.underscore
    # available icons defined by html files with svg icons inside in 'app/views/categories/icons'
    avl_icons = %w(american_football classical golf motor_racing special_events
                   baseball concerts hockey motorcycling tennis basketball
                   cricket horse_racing olympics theater boxing football mma
                   rugby)
    avl_icons.include?(key) ? render("categories/icons/#{key}") : ''
  end

  # Method returns correct char symbol to ticket's currency
  # Params:
  #   ticket - object of Ticket class
  def currency_symbol(ticket)
    case ticket.currency
    when 'Pounds' then '£'
    when 'Dollars' then '$'
    else '€'
    end
  end

  def currency_code(ticket)
    case ticket.currency
    when 'Pounds' then 'GBP'
    when 'Dollars' then 'USD'
    else 'EUR'
    end
  end

end
