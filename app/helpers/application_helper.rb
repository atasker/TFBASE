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
      venue.events.each do |event|
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

end
