class TicketsController < BaseFrontendController

  def show
    @ticket = Ticket.find(params[:id])
    @event = @ticket.event
    @category = @event.category if @event
    @competition = Competition.find(params[:comp]) if params[:comp]
    unless @competition || @event.nil? || @event.competition.blank?
      @competition = @event.competition
    end
    @player = Player.find(params[:player]) if params[:player]

    add_common_breadcrumbs! @category, @competition, @player, @event, @ticket
  end

end
