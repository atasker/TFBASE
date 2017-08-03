class EventsController < BaseFrontendController

  def index
    @events = Event.text_search(params[:query])
    @sorted = @events.sort { |a,b| a.start_time <=> b.start_time }
  end

  def show
    @event = Event.find(params[:id])
    @category = Category.find(@event.category_id)
    @category_description = Category.find(@event.category_id).description
    gon.latitude = @event.venue.latitude
    gon.longitude = @event.venue.longitude
    if params[:comp]
      @competition = Competition.find(params[:comp])
    elsif @event.competition_id != nil
      @competition = Competition.find(@event.competition_id)
    end
    if params[:player]
      @player = Player.find(params[:player])
    end

    if @event.tickets.count > 0
      @currency = @event.tickets.first.currency
      if @currency == "Pounds"
        @symbol = "£"
      elsif @currency == "Dollars"
        @symbol = "$"
      else
        @symbol = "€"
      end
    end

    @tickets = @event.tickets
    @sorted_tickets = @tickets.sort { |a,b| a.price <=> b.price }
  end

end
