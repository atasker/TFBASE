class Admin::EventsController < AdminController

  def index
    if params[:search] == "archive"
      @events = Event.where('start_time < ?', DateTime.now).order(:start_time)
    elsif params[:search]
      @events = Event.search(params[:search]).order(:start_time)
    else
      @events = Event.actual.order(:start_time)
    end
    @events = @events.includes(:venue, :category)
    @events = @events.page(params[:page]).per(100)
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    @tickets = @event.tickets.includes(:event)
  end

  def new
    @event = Event.new
  end

  def archive
    @events = Event.where('start_time < ?', DateTime.now).order(:start_time)
  end


  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html do
          redirect_to admin_event_path(@event.id),
                      notice: 'Event was successfully created'
        end
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
      redirect_to admin_event_path(@event.id)
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
    params.require(:event).permit(
      :name, :slug, :start_time, :venue_id,
      :category_id, :competition_id,
      :sports, :priority,
      :no_title_postfix, :seo_title, :seo_descr, :seo_keywords,
      player_ids: [],
      tickets_attributes: [
        :id, :price, :category, :quantity, :currency,
        :enquire, :text, :pairs_only, :_destroy],
      info_blocks_attributes: [
        :id, :title, :text, :prior, :_destroy])
  end

end
