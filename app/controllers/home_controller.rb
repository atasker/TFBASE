class HomeController < BaseFrontendController

  def index
    @is_homepage = true

    @top_slides = HomeSlide.where(kind: HomeSlide::KIND_TOP_SLIDE).ordered
    @featured_slides = HomeSlide.where(kind: HomeSlide::KIND_FEATURED_EVENT).ordered
    @top_events = HomeSlide.where(kind: HomeSlide::KIND_TOP_EVENT).ordered.limit(4)
    @popular_events = HomeSlide.where(kind: HomeSlide::KIND_POPULAR_EVENT).ordered
    @main_services = HomeLineItem.ordered

    # Main categories (line under top slider)
    @main_categories = {}
    Category.select(:id, :description).
             where(description: %w(Theater Classical Concerts)).
             each do |spec_category|
      @main_categories[spec_category.description] = spec_category.id
    end

    ## That three commented lines of code was before me
    # @sports = Event.where(sports: true).sample(3)
    # @concerts_id = Category.where(description: "Concerts").ids
    # @music = Event.where(category_id: @concerts_id).sample(3)
  end

end
