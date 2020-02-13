class CompetitionsController < BaseFrontendController

  def show
    @competition, needs_redirect = find_by_slug_with_fallback Competition, params[:id]
    if needs_redirect
      redirect_to competition_path(@competition.slug), status: :moved_permanently
      return
    end

    @category = @competition.category

    @players = Player.joins(:events).
                      where(events: { competition: @competition }).
                      order(name: :asc).
                      group(:id)
    @players = @players.to_a

    if @players.size > 0
      # for the filter works
      @players_venues = Venue.joins(events: [:players]).
                              where('(events.start_time >= ? OR events.start_time IS NULL)', DateTime.now).
                              where(players: { id: @players.collect { |pl| pl.id } }).
                              group(:id)
    else
      @events = @competition.events.order(start_time: :asc)
      @events, @event_count_before_filtration = apply_day_filter_to_events @events
    end

    @page_meta = @competition

    @structured_data = []
    if @events.any?
      json_data = @events.map{|evt| evt.json_structured_data}
      json_data.each do |dt|
        @structured_data << JSON.parse(dt.to_json_as_root)
      end
    end

    add_common_breadcrumbs! @category, @competition
  end

end
