class CompetitionsController < BaseFrontendController

  def show
    @competition = Competition.find_by_slug params[:id]
    unless @competition
      @competition = Competition.find params[:id]
      if @competition.slug.present?
        redirect_to competition_path(@competition.slug), status: :moved_permanently
        return
      end
    end

    @category = @competition.category
    @events = @competition.events.order(start_time: :asc)

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

    @tmp = []
    @events.each do |event|
      event.players.each do |player|
        @tmp << player unless @tmp.include?(player)
      end
    end
    @players = @tmp.sort { |a,b| a.name <=> b.name }

    # for the filter works
    @players_venues = Venue.joins(events: [:players]).
                            where('events.start_time >= ?', DateTime.now).
                            where(players: { id: @players.collect { |pl| pl.id } }).
                            group(:id)

    @page_meta = { title: @competition.name,
                   description: @competition.name,
                   image: @competition.avatar.grid_large.url }

    add_breadcrumb 'Categories', categories_path
    add_breadcrumb @category.description, category_path(@category)
    add_breadcrumb @competition.name, nil
  end

end
