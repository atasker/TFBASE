class Admin::EventsController < AdminController

  def index
    @events = Event.where('start_time > ?', DateTime.now)
    @event = Event.new
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

    respond_to do |format|
      if @event.save
        format.html { redirect_to [:admin, @event], notice: 'Event was successfully created' }
        format.js { }
      else
        format.html { render 'new' }
        format.js { @errors = @event.errors.full_messages.join(". ") }
      end
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
