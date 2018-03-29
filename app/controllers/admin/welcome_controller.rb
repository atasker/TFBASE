class Admin::WelcomeController < AdminController

  def index
    @categories = Category.all
    @competitions = Competition.all
    @events = Event.all
    @players = Player.all
    @tickets = Ticket.all
    @venues = Venue.all
    @pages = Page.all
  end

end
