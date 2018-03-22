class PlayersController < BaseFrontendController

  def show
    need_redirect = false

    if params[:comp].present? && params[:compet].blank?
      params[:compet] = params[:comp]
      need_redirect = true # because this old url where ...?comp={id}
    end

    if params[:compet]
      @competition, ask_redirect = find_by_slug_with_fallback Competition, params[:compet]
      need_redirect = true if ask_redirect # because new url uses slug instead of id
    end

    @player, ask_redirect = find_by_slug_with_fallback Player, params[:id]
    need_redirect = true if ask_redirect # because new url uses slug instead of id

    if need_redirect
      ppth = player_path(@player)
      ppth = competition_player_path(@player, compet: @competition) if @competition
      redirect_to ppth, status: :moved_permanently
      return
    end

    @category = @player.category

    @events = @player.events.order(start_time: :asc)
    @events = @events.where(competition: @competition) if @competition
    @events, @event_count_before_filtration = apply_day_filter_to_events @events

    @page_meta = OpenStruct.new(title: @player.name,
                                seo_descr: @player.name,
                                seo_image: @player.avatar.grid_large.url)

    add_common_breadcrumbs! @category, @competition, @player
  end

end
