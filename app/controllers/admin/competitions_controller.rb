class Admin::CompetitionsController < AdminController

  def index
    @competitions = Competition.all.includes(:category)
  end

  def show
    @competition = Competition.find(params[:id])
    @events = @competition.events
  end

  def new
    @competition = Competition.new
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def create
    @competition = Competition.new(competition_params)

    if @competition.save
      flash[:notice] = "Competition successfully created"
      redirect_to admin_competition_path(@competition.id)
    else
      render 'new'
    end
  end

  def update
    @competition = Competition.find(params[:id])

    if @competition.update(competition_params)
      flash[:notice] = "Competition successfully updated"
      redirect_to admin_competition_path(@competition.id)
    else
      render 'edit'
    end
  end

  def destroy
    @competition = Competition.find(params[:id])
    @competition.destroy
    flash[:notice] = "Competition successfully deleted"
    redirect_to admin_competitions_path
  end

  private

  def competition_params
    params.require(:competition).permit(
      :name, :slug, :category_id, :text, :avatar,
      :no_title_postfix, :seo_title, :seo_descr, :seo_keywords,
      tabs_attributes: [:id, :name, :content, :prior, :_destroy])
  end

end
