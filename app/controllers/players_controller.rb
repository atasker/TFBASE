class PlayersController < BaseFrontendController

  def show
    need_redirect = false

    if params[:comp].present? && params[:compet].blank?
      params[:compet] = params[:comp]
      need_redirect = true # because this old url where ...?comp={id}
    end

    if params[:compet]
      @competition = Competition.find_by_slug params[:compet]
      unless @competition
        @competition = Competition.find params[:compet]
        if @competition.slug.present?
          need_redirect = true # because new url uses slug instead of id
        end
      end
    end

    @player = Player.find_by_slug params[:id]
    unless @player
      @player = Player.find params[:id]
      if @player.slug.present?
        need_redirect = true # because new url uses slug instead of id
      end
    end

    if need_redirect
      if @competition
        redirect_to competition_player_path(@player, compet: @competition),
                    status: :moved_permanently
      else
        redirect_to player_path(@player.slug), status: :moved_permanently
      end
      return
    end

    @category = @player.category

    if @competition
      @all_events = Event.where(competition_id: @competition.id)
    else
      @all_events = Event.all
    end

    @event_count_before_filtration = @all_events.actual.count

    if params[:dt].present?
      begin
        @start_date = Date.parse params[:dt]
        @all_events = @all_events.where("start_time >= ?", @start_date)
      rescue
        @all_events = @all_events.actual
      end
    else
      @all_events = @all_events.actual
    end

    @tmp = []
    @all_events.each do |event|
      event.players.each do |player|
        if @player == player
          @tmp << event
        end
      end
    end
    @events = @tmp.sort { |a,b| a.start_time <=> b.start_time }

    @page_meta = { title: @player.name,
                   description: @player.name,
                   image: @player.avatar.grid_large.url }

    add_breadcrumb 'Categories', categories_path
    add_breadcrumb @category.description, category_path(@category)
    if @competition
      add_breadcrumb @competition.name, competition_path(@competition)
    end
    add_breadcrumb @player.name, nil
  end

end
