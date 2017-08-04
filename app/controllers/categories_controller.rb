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

    add_breadcrumb 'Categories', categories_path
    add_breadcrumb @category.description, nil
  end

end
