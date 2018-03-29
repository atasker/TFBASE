class BaseFrontendController < ApplicationController

  before_filter :collect_categories, :add_home_breadcrumb

  helper_method :page_meta, :add_breadcrumb, :breadcrumbs

  protected

  def determine_page(checked_path = nil)
    @current_page = nil
    checked_path ||= request.fullpath # try to find page for current url
    if path_match = checked_path.match(/^\/?([^\?]*)\??/)
      @current_page = Page.find_by_path path_match[1]
    end
  end

  def page_meta
    unless @page_meta_carrier
      unless @page_meta
        @page_meta = OpenStruct.new(
          seo_descr: 'Buy tickets to concerts, sports, arts, theater and hard ' \
                     'to find sold out events worldwide.')
      end
      @page_meta_carrier = Seo::Basic.new @page_meta, false
    end
    @page_meta_carrier
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path)
    self.breadcrumbs << { name: name, path: path }
  end

  protected

  def find_by_slug_with_fallback objClass, search_str
    unless [Category, Competition, Player, Event].include? objClass
      raise ActionController::RoutingError, "Routing error"
    end
    obj = objClass.find_by_slug search_str
    ask_for_redirect = false
    unless obj
      obj = objClass.find search_str
      ask_for_redirect = obj.slug.present?
    end
    return obj, ask_for_redirect
  end

  def apply_day_filter_to_events(events_scope)
    count_before_filtration = events_scope.actual.count
    if params[:dt].present?
      begin
        @start_date = Date.parse params[:dt]
        events_scope = events_scope.where("events.start_time >= ?", @start_date)
      rescue
        events_scope = events_scope.actual
      end
    else
      events_scope = events_scope.actual
    end
    return events_scope, count_before_filtration
  end

  def add_common_breadcrumbs!(category = nil, competition = nil, player = nil,
                                                    event = nil, ticket = nil)
    if category
      add_breadcrumb 'Categories', categories_path
      add_breadcrumb category.description, category_path(category)
    end

    if competition
      add_breadcrumb competition.name, competition_path(competition)
    end

    if player
      ppth = player_path(player)
      ppth = competition_player_path(player, compet: competition) if competition
      add_breadcrumb player.name, ppth
    end

    if event
      add_breadcrumb event.name, event_path(event, player: (player ? player.id : nil))
    end
    add_breadcrumb 'Ticket', ticket_path(ticket) if ticket
  end

  private

  def collect_categories
    @categories = Category.order('description ASC')
  end

  def add_home_breadcrumb
    add_breadcrumb 'Home', root_path
  end

end
