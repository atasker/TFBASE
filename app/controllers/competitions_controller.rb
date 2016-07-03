class CompetitionsController < ApplicationController

  def show
    @competition = Competition.find(params[:id])
    @category = Category.find(@competition.category_id)
    @events = Event.where(competition_id: @competition.id)
    @sorted = @events.sort { |a,b| a.start_time <=> b.start_time }

    @tmp = []
    @events.each do |event|
      event.players.each do |player|
        @tmp << player unless @tmp.include?(player)
      end
    end
    @players = @tmp.sort { |a,b| a.name <=> b.name }
  end

end
