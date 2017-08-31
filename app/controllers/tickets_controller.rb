class TicketsController < BaseFrontendController

  def show
    @ticket = Ticket.find(params[:id])
    @event = @ticket.event

    if @event
      # Code in this condition block is copied from events controller
      # From this >
      @category = Category.find(@event.category_id)
      if params[:comp]
        @competition = Competition.find(params[:comp])
      elsif @event.competition_id != nil
        @competition = Competition.find(@event.competition_id)
      end
      if params[:player]
        @player = Player.find(params[:player])
      end

      if @category
        add_breadcrumb 'Categories', categories_path
        add_breadcrumb @category.description, category_path(@category)
      end
      if @competition
        add_breadcrumb @competition.name, competition_path(@competition)
      end
      if @player
        if @competition
          add_breadcrumb @player.name, competition_player_path(@player, compet: @competition)
        else
          add_breadcrumb @player.name, player_path(@player)
        end
      end
      # < To that.
      # Maybe better use concern method for it? Need to think about it later.
      add_breadcrumb @event.name, event_path(@event)
    end

    add_breadcrumb 'Ticket', nil
  end

end
