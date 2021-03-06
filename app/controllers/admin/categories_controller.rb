class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @events = @category.events
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category successfully created"
      redirect_to admin_category_path(@category.id)
    else
      render 'new'
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      flash[:notice] = "Category successfully updated"
      redirect_to admin_category_path(@category.id)
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Category successfully deleted"
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(
      :description, :slug, :sports, :text,
      :no_title_postfix, :seo_title, :seo_descr, :seo_keywords,
      tabs_attributes: [:id, :name, :content, :prior, :_destroy])
  end

end
