class BaseFrontendController < ApplicationController

  before_filter :collect_categories, :add_home_breadcrumb

  helper_method :page_meta, :add_breadcrumb, :breadcrumbs

  protected

  def page_meta
    unless @page_meta_carrier
      def_title = 'TicketFinders | Tickets for Concerts, Sports, Opera, Theater'
      if @page_meta
        @page_meta_carrier = {
          title: "#{@page_meta[:title]} Tickets - #{def_title}",
          description: "Buy #{@page_meta[:description]} tickets from the official Ticket-Finders.com site.",
          image: @page_meta[:image]
        }
      else
        @page_meta_carrier = {
          title: def_title,
          description: 'Buy tickets to concerts, sports, arts, theater and hard to find sold out events worldwide.',
          image: nil
        }
      end
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
