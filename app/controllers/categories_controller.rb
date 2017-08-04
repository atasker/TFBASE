class CategoriesController < BaseFrontendController

  def index
    @categories = Category.order('description ASC')
    add_breadcrumb 'Categories', nil
  end

  def show
    @category = Category.find(params[:id])
    @players = Player.where(category_id: @category.id).order('name ASC')
    @competitions = Competition.where(category_id: @category.id).order('name ASC')
    @events = Event.where(category_id: @category.id).order(start_time: :asc)

    add_breadcrumb 'Categories', categories_path
    add_breadcrumb @category.description, nil
  end

end
