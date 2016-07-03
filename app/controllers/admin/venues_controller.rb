class Admin::VenuesController < AdminController

  def index
    @venues = Venue.all
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def new
    @venue = Venue.new
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      flash[:notice] = "Venue successfully created"
      redirect_to [:admin, @venue]
    else
      render 'new'
    end
  end

  def update
    @venue = Venue.find(params[:id])

    if @venue.update(venue_params)
      flash[:notice] = "Venue successfully updated"
      redirect_to [:admin, @venue]
    else
      render 'edit'
    end
  end

  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy
    flash[:notice] = "Venue successfully deleted"
    redirect_to admin_venues_path
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :capacity, :city, :country, :address, :latitude, :longitude, :avatar)
  end

end
