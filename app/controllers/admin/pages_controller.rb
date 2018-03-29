class Admin::PagesController < AdminController

  def index
    @pages = Page.order id: :asc
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      flash[:notice] = "Page successfully created"
      redirect_to admin_page_path(@page.id)
    else
      render 'new'
    end
  end

  def update
    @page = Page.find(params[:id])

    if @page.update(page_params)
      flash[:notice] = "Page successfully updated"
      redirect_to admin_page_path(@page.id)
    else
      render 'edit'
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    if @page.destroyed?
      flash[:notice] = "Page successfully deleted"
    else
      flash[:notice] = "Can't destroy the page"
    end
    redirect_to admin_pages_path
  end

  private

  def page_params
    params.require(:page).permit(
      :title, :path, :body,
      :no_title_postfix, :seo_title, :seo_descr, :seo_keywords)
  end

end
