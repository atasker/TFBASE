class CategoriesController < BaseFrontendController

  def index
    @categories = Category.order('description ASC')
    add_breadcrumb 'Categories', nil
  end

  def show
    @category = Category.find_by_slug params[:id]
    unless @category
      @category = Category.find params[:id]
      if @category.slug.present?
        redirect_to category_path(@category.slug), status: :moved_permanently
        return
      end
    end

    @competitions = @category.competitions.order(name: :asc)
    @players = @category.players.order(name: :asc)
    @events = @category.events.order(start_time: :asc)

    # for the filter works
    @competitions_venues = Venue.joins(events: [:competition]).
                                 where('events.start_time >= ?', DateTime.now).
                                 where(competitions: { id: @competitions.pluck(:id) }).
                                 group(:id)
    @players_venues = Venue.joins(events: [:players]).
                            where('events.start_time >= ?', DateTime.now).
                            where(players: { id: @players.pluck(:id) }).
                            group(:id)

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

    add_breadcrumb 'Categories', categories_path
    add_breadcrumb @category.description, nil
  end

end
