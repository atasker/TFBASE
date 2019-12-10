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
    @event = if params[:selected_events].present?
      Event.find params[:selected_events].first
    else
      Event.find(params[:id])
    end
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
    updated = true
    selected_events_id = params[:selected_events].split(',') if params[:selected_events].present?
    if selected_events_id.present?
      @event = Event.find(params[:selected_events].first)
      events = Event.find selected_events_id
      update_all_event_params[:info_blocks_attributes].each do |event_params|
        title = event_params.last[:title]
        text = event_params.last[:text]
        destroy = event_params.last[:_destroy]
        events.each do |ee|
          info_block = ee.info_blocks.where(title: title).first
          if info_block.present?
            if destroy
              info_block.destroy
            else
              info_block.update(title: title, text: text)
            end
          else
            ee.info_blocks.create(title: title, text: text)
          end
        end
      end
    else
      @event = Event.find(params[:id])
      updated = false unless @event.update(event_params)
    end
    if updated
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

  def destroy_many
    event_ids = params[:ids].split(',').compact
    logger.info('event_ids')
    logger.debug(event_ids)
    Event.where(id: event_ids.compact).destroy_all
    flash[:notice] = "Selected events successfully deleted"
    redirect_to admin_events_path
  end

  private

  def event_params
    params.require(:event).permit(
      :name, :slug, :start_time, :tbc, :venue_id,
      :category_id, :competition_id,
      :sports, :priority,
      :no_title_postfix, :seo_title, :seo_descr, :seo_keywords,
      player_ids: [],
      tickets_attributes: [
        :id, :price, :fee_percent, :face_value, :category, :quantity,
        :currency, :enquire, :text, :pairs_only, :_destroy],
      info_blocks_attributes: [
        :id, :title, :text, :prior, :_destroy])
  end

  def update_all_event_params
    params.require(:event).permit(info_blocks_attributes: [:id, :title, :text, :prior, :_destroy])
  end
end
