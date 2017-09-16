class CompetitionsController < BaseFrontendController

  def show
    @competition, needs_redirect = find_by_slug_with_fallback Competition, params[:id]
    if needs_redirect
      redirect_to competition_path(@competition.slug), status: :moved_permanently
      return
    end

    @category = @competition.category

    @players = @competition.players

    if @players.count > 0
      # for the filter works
      @players_venues = Venue.joins(events: [:players]).
                              where('events.start_time >= ?', DateTime.now).
                              where(players: { id: @players.pluck(:id) }).
                              group(:id)
    else
      @events = @competition.events.order(start_time: :asc)
      @events, @event_count_before_filtration = apply_day_filter_to_events @events
    end

    @page_meta = { title: @competition.name,
                   description: @competition.name,
                   image: @competition.avatar.grid_large.url }

    add_common_breadcrumbs! @category, @competition
  end

end
