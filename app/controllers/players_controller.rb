class PlayersController < ApplicationController

  def show
    @player = Player.find(params[:id])
    @category = Category.find(@player.category_id)
    if params[:comp]
      @competition = Competition.find(params[:comp])
      # Retrieve all events in the given competition
      @all_events = Event.where(competition_id: @competition.id)
      # Return player specific events
      @tmp = []
      @all_events.each do |event|
        event.players.each do |player|
          if player == @player
            @tmp << event
          end
        end
      end
      @events = @tmp.sort { |a,b| a.start_time <=> b.start_time }
    else
      @all_events = Event.all
      @tmp = []
      @all_events.each do |event|
        event.players.each do |player|
          if @player == player
            @tmp << event
          end
        end
      end
      @events = @tmp.sort { |a,b| a.start_time <=> b.start_time }
    end
  end

end
