class Admin::HomeLineItemsController < AdminController

  def index
    @home_line_items = HomeLineItem.ordered
  end

  def show
    @home_line_item = HomeLineItem.find(params[:id])
  end

  def new
    @home_line_item = HomeLineItem.new
  end

  def edit
    @home_line_item = HomeLineItem.find(params[:id])
  end

  def create
    @home_line_item = HomeLineItem.new(home_line_item_params)

    if @home_line_item.save
      flash[:notice] = "Home \"#Popular Event\" line item successfully created"
      redirect_to admin_home_line_item_path(@home_line_item)
    else
      render 'new'
    end
  end

  def update
    @home_line_item = HomeLineItem.find(params[:id])

    if @home_line_item.update(home_line_item_params)
      flash[:notice] = "\"#Popular Event\" line item successfully updated"
      redirect_to action: :show
    else
      render 'edit'
    end
  end

  def destroy
    @home_line_item = HomeLineItem.find(params[:id])
    @home_line_item.destroy
    flash[:notice] = "\"#Popular Event\" line item successfully deleted"
    redirect_to admin_home_line_items_path
  end

  private

  def home_line_item_params
    params.require(:home_line_item).permit(:kind,
                                           :title, :url, :avatar, :avatar_cache,
                                           :competition_id, :player_id,
                                           :prior)
  end

end
