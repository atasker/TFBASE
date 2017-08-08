class CompetitionsController < BaseFrontendController

  def show
    @competition = Competition.find(params[:id])
    @category = @competition.category
    @events = @competition.events.order(start_time: :asc)

    @event_count_before_filtration = @events.count

    if params[:dt].present?
      begin
        @start_date = Date.parse params[:dt]
        @events = @events.where("events.start_time >= ?", @start_date)
      rescue
        # just do nothing
      end
    end

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
