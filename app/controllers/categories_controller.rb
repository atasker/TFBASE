class CategoriesController < BaseFrontendController

  def index
    # @categories already initialized at collect_categories method of BaseFrontendController
    add_breadcrumb 'Categories', nil
  end

  def show
    @category, needs_redirect = find_by_slug_with_fallback Category, params[:id]
    if needs_redirect
      redirect_to category_path(@category.slug), status: :moved_permanently
      return
    end

    @competitions = @category.competitions.order(name: :asc)
    if @competitions.count > 0
      # for the filter works
      @competitions_venues = Venue.joins(events: [:competition]).
                                   where('events.start_time >= ?', DateTime.now).
                                   where(competitions: { id: @competitions.pluck(:id) }).
                                   group(:id)
    else
      @players = @category.players.order(name: :asc)
      if @players.count > 0
        # for the filter works
        @players_venues = Venue.joins(events: [:players]).
                                where('events.start_time >= ?', DateTime.now).
                                where(players: { id: @players.pluck(:id) }).
                                group(:id)
      else
        @events = @category.events.order(start_time: :asc)
        @events, @event_count_before_filtration = apply_day_filter_to_events @events
      end
    end

    add_common_breadcrumbs! @category
  end

end
