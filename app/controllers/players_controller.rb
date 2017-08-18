class PlayersController < BaseFrontendController

  def show
    @player = Player.find(params[:id])
    @category = @player.category

    if params[:comp]
      @competition = Competition.find(params[:comp])
      # Retrieve all events in the given competition
      @all_events = Event.where(competition_id: @competition.id)
    else
      @all_events = Event.all
    end

    @event_count_before_filtration = @all_events.actual.count

    if params[:dt].present?
      begin
        @start_date = Date.parse params[:dt]
        @all_events = @all_events.where("start_time >= ?", @start_date)
      rescue
        @all_events = @all_events.actual
      end
    else
      @all_events = @all_events.actual
    end

    @tmp = []
    @all_events.each do |event|
      event.players.each do |player|
        if @player == player
          @tmp << event
        end
      end
    end
    @events = @tmp.sort { |a,b| a.start_time <=> b.start_time }

    @page_meta = { title: @player.name,
                   description: @player.name,
                   image: @player.avatar.grid_large.url }

    add_breadcrumb 'Categories', categories_path
    add_breadcrumb @category.description, category_path(@category)
    if @competition
      add_breadcrumb @competition.name, competition_path(@competition)
    end
    add_breadcrumb @player.name, nil
  end

end
