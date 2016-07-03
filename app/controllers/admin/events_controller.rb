class Admin::EventsController < AdminController

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)
    @players = Player.where(:id => params[:event_players])
    @event.players << @players

    if @event.save
      flash[:notice] = "Event successfully created"
      redirect_to [:admin, @event]
    else
      render 'new'
    end
  end

  def update
    @event = Event.find(params[:id])
    @players = Player.where(:id => params[:event_players])
    @event.players.destroy_all
    @event.players << @players

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
                                  :sports, :priority)
  end

end
