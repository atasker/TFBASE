class CompetitionsController < BaseFrontendController

  def show
    @competition = Competition.find(params[:id])
    @category = @competition.category
    @events = @competition.events.order(start_time: :asc)

    @tmp = []
    @events.each do |event|
      event.players.each do |player|
        @tmp << player unless @tmp.include?(player)
      end
    end
    @players = @tmp.sort { |a,b| a.name <=> b.name }

    @page_meta = { title: @competition.name,
                   description: @competition.name }

    add_breadcrumb 'Categories', categories_path
    add_breadcrumb @category.description, category_path(@category)
    add_breadcrumb @competition.name, nil
  end

end
