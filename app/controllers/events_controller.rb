class EventsController < BaseFrontendController

  def index
    @events = Event.text_search(params[:query])
    @events, @event_count_before_filtration = apply_day_filter_to_events @events
    @sorted = @events.sort { |a,b| a.start_time <=> b.start_time }

    add_breadcrumb 'Search Results', nil
  end

  def show
    @event, needs_redirect = find_by_slug_with_fallback Event, params[:id]
    if needs_redirect
      redirect_to event_path(@event.slug), status: :moved_permanently
      return
    end

    @category = Category.find(@event.category_id)
    @competition = Competition.find(params[:comp]) if params[:comp]
    unless @competition || @event.competition.blank?
      @competition = @event.competition
    end
    @player = Player.find(params[:player]) if params[:player]

    gon.latitude = @event.venue.latitude
    gon.longitude = @event.venue.longitude
    gon.placename = @event.venue.address

    @tickets = @event.tickets.order(price: :asc)
    @event_have_tickets = @tickets.any?
    @event_have_buyable_tickets = @tickets.buyable.sum(:quantity) > 0

    if @competition
      @event.seo_image = @competition.avatar.grid_large.url
    elsif @player
      @event.seo_image = @player.avatar.grid_large.url
    end

    @page_meta = @event

    add_common_breadcrumbs! @category, @competition, @player, @event
  end

end
