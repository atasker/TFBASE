class Admin::TicketsController < AdminController

  def index
    @tickets = Ticket.all
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def new
    @ticket = Ticket.new
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def create
    @ticket = Ticket.new(ticket_params)

    if @ticket.save
      flash[:notice] = "Ticket successfully created"
      redirect_to [:admin, @ticket]
    else
      render 'new'
    end
  end

  def update
    @ticket = Ticket.find(params[:id])

    if @ticket.update(ticket_params)
      flash[:notice] = "Ticket successfully updated"
      redirect_to [:admin, @ticket]
    else
      render 'edit'
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    flash[:notice] = "Ticket successfully deleted"
    redirect_to admin_tickets_path
  end

  private

  def ticket_params
    params.require(:ticket).permit(:price, :category, :quantity, :event_id, :text, :currency, :pairs_only)
  end

end
