class Admin::EventsController < AdminController

  def index
    if params["venue_id"]
      @venue = Venue.find(params[:venue_id])
      @events = Event.where(venue_id: @venue.id)
    else
      @events = Event.all
      @event = Event.new
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    if params["venue_id"]
      @venue = Venue.find(params[:venue_id])
    else
      @event = Event.new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
    else
      @errors = @event.errors.full_messages.join(". ")
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:notice] = "Event successfully updated"
      redirect_to [:admin, @event]
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = "Event successfully deleted"
    redirect_to admin_events_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :start_time, :venue_id,
                                  :category_id, :competition_id,
                                  :sports, :priority, player_ids: [])
  end

end
