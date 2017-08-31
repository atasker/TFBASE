class EventsController < BaseFrontendController

  def index
    @events = Event.text_search(params[:query])
    @event_count_before_filtration = @events.actual.count
    if params[:dt].present?
      begin
        @start_date = Date.parse params[:dt]
        @events = @events.where("events.start_time >= ?", @start_date)
      rescue
        @events = @events.actual
      end
    else
      @events = @events.actual
    end
    @sorted = @events.sort { |a,b| a.start_time <=> b.start_time }

    add_breadcrumb 'Search Results', nil
  end

  def show
    @event = Event.find_by_slug params[:id]
    unless @event
      @event = Event.find params[:id]
      if @event.slug.present?
        redirect_to event_path(@event.slug), status: :moved_permanently
        return
      end
    end

    @category = Category.find(@event.category_id)
    if params[:comp]
      @competition = Competition.find(params[:comp])
    elsif @event.competition_id != nil
      @competition = Competition.find(@event.competition_id)
    end
    if params[:player]
      @player = Player.find(params[:player])
    end

    gon.latitude = @event.venue.latitude
    gon.longitude = @event.venue.longitude
    gon.placename = @event.venue.address

    @tickets = @event.tickets
    @event_have_tickets = @tickets.sum(:quantity) > 0
    @sorted_tickets = @tickets.sort { |a,b| a.price <=> b.price }

    page_meta_image_url = nil
    if @competition
      page_meta_image_url = @competition.avatar.grid_large.url
    elsif @player
      page_meta_image_url = @player.avatar.grid_large.url
    end
    @page_meta = { title: @event.name,
                   description: @event.name,
                   image: page_meta_image_url }

    if @category
      add_breadcrumb 'Categories', categories_path
      add_breadcrumb @category.description, category_path(@category)
    end
    if @competition
      add_breadcrumb @competition.name, competition_path(@competition)
    end
    if @player
      if @competition
        add_breadcrumb @player.name, competition_player_path(@player, compet: @competition)
      else
        add_breadcrumb @player.name, player_path(@player)
      end
    end
    add_breadcrumb @event.name, nil
  end

end
