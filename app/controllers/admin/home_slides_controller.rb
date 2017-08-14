class Admin::HomeSlidesController < AdminController

  def index
    determine_kind
    @home_slides = HomeSlide.where(kind: @slides_kind).ordered
  end

  def show
    determine_kind
    @home_slide = HomeSlide.where(kind: @slides_kind).find(params[:id])
  end

  def new
    determine_kind
    @home_slide = HomeSlide.new kind: @slides_kind
    @home_slide.manual_input = false
  end

  def edit
    determine_kind
    @home_slide = HomeSlide.where(kind: @slides_kind).find(params[:id])
  end

  def create
    determine_kind
    @home_slide = HomeSlide.new(home_slide_params)
    @home_slide.kind = @slides_kind

    if @home_slide.save
      flash[:notice] = "#{@kind_human_name} successfully created"
      redirect_to admin_home_slide_path(slides_kind: @kind_option, id: @home_slide.id)
    else
      render 'new'
    end
  end

  def update
    determine_kind
    @home_slide = HomeSlide.where(kind: @slides_kind).find(params[:id])

    if @home_slide.update(home_slide_params)
      flash[:notice] = "#{@kind_human_name} successfully updated"
      redirect_to action: :show
    else
      render 'edit'
    end
  end

  def destroy
    determine_kind
    @home_slide = HomeSlide.where(kind: @slides_kind).find(params[:id])
    @home_slide.destroy
    flash[:notice] = "#{@kind_human_name} successfully deleted"
    redirect_to admin_home_slides_path(slides_kind: @kind_option)
  end

  private

  def determine_kind
    @slides_kind = %w(top_slides featured_events top_events popular_events).index(params[:slides_kind])
    raise ActiveRecord::RecordNotFound, "Record not found" if @slides_kind.nil?
    @kind_option = params[:slides_kind]
    @kind_human_name = ['Top slide', 'Featured event',
                        'Top event', 'Popular event'][@slides_kind]
  end

  def home_slide_params
    params.require(:home_slide).permit(
      :huge_image, :huge_image_cache, :big_image, :big_image_cache,
      :tile_image, :tile_image_cache, :avatar, :avatar_cache,
      :manual_input, :event_id,
      :title, :url, :place, :start_date, :end_date, :category_id,
      :prior)
  end

end
