class CategoriesController < BaseFrontendController

  def index
    @categories = Category.order('description ASC')
    add_breadcrumb 'Categories', nil
  end

  def show
    @category = Category.find(params[:id])
    @competitions = @category.competitions.order(name: :asc)
    @players = @category.players.order(name: :asc)
    @events = @category.events.order(start_time: :asc)

    @event_count_before_filtration = @events.count

    if params[:dt].present?
      begin
        @start_date = Date.parse params[:dt]
        @events = @events.where("events.start_time >= ?", @start_date)
      rescue
        # just do nothing
      end
    end

    add_breadcrumb 'Categories', categories_path
    add_breadcrumb @category.description, nil
  end

end
