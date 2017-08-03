class BaseFrontendController < ApplicationController

  before_filter :collect_categories

  def page_meta
    unless @page_meta_carrier
      def_title = 'TicketFinders | Tickets for Concerts, Sports, Opera, Theater'
      if @page_meta
        @page_meta_carrier = {
          title: "#{@page_meta[:title]} Tickets - #{def_title}",
          description: "Buy #{@page_meta[:description]} tickets from the official Ticket-Finders.com site."
        }
      else
        @page_meta_carrier = {
          title: def_title,
          description: 'Buy tickets to concerts, sports, arts, theater and hard to find sold out events worldwide.'
        }
      end
    end
    @page_meta_carrier
  end

  helper_method :page_meta

  private

  def collect_categories
    @categories = Category.order('description ASC')
  end

end
