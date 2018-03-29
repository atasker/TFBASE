class HomeController < BaseFrontendController

  def index
    @is_homepage = true

    @top_slides = HomeSlide.where(kind: HomeSlide::KIND_TOP_SLIDE).ordered.includes(:category, event: [:venue, :category])
    @featured_slides = HomeSlide.where(kind: HomeSlide::KIND_FEATURED_EVENT).ordered.includes(:category, event: [:venue, :category])
    @top_events = HomeSlide.where(kind: HomeSlide::KIND_TOP_EVENT).ordered.limit(4).includes(:category, event: [:venue, :category])
    @popular_events = HomeSlide.where(kind: HomeSlide::KIND_POPULAR_EVENT).ordered.includes(:category, event: [:venue, :category])
    @main_services = HomeLineItem.ordered.includes(:competition, :player)

    # Main categories (line under top slider)
    @main_categories = {}
    Category.select(:id, :description).
             where(description: %w(Theater Classical Concerts)).
             each do |spec_category|
      @main_categories[spec_category.description] = spec_category.id
    end

    determine_page
    @page_meta = OpenStruct.new(
      seo_descr: @current_page.seo_descr,
      seo_keywords: @current_page.seo_keywords
    ) if @current_page

    ## That three commented lines of code was before me
    # @sports = Event.where(sports: true).sample(3)
    # @concerts_id = Category.where(description: "Concerts").ids
    # @music = Event.where(category_id: @concerts_id).sample(3)
  end

end
