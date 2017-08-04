class TicketsController < BaseFrontendController

  def show
    @ticket = Ticket.find(params[:id])
    @event = @ticket.event
    if @ticket.currency == "Dollars"
      @symbol = "$"
    elsif @ticket.currency == "Pounds"
      @symbol = "£"
    else
      @symbol = "€"
    end

    add_breadcrumb @event.name, event_path(@event)
    add_breadcrumb 'Ticket', nil
  end

end
