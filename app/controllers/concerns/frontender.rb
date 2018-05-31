module Frontender
  extend ActiveSupport::Concern

  included do
    before_filter :determine_cart, :collect_categories, :add_home_breadcrumb
    helper_method :page_meta, :add_breadcrumb, :breadcrumbs
  end

  protected

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

  private

  def determine_cart
    if user_signed_in?
      @cart = current_user.cart
    else
      @cart = session[:cart] ? Cart.find_by_id(session[:cart]) : nil
    end
  end

  def collect_categories
    @categories = Category.order('description ASC')
  end

  def add_home_breadcrumb
    add_breadcrumb 'Home', root_path
  end
end
