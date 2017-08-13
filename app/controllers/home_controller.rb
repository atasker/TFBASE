class HomeController < BaseFrontendController

  def index
    @is_homepage = true

    @top_slides = HomeSlide.where(kind: HomeSlide::KIND_TOP_SLIDE).ordered
    @featured_slides = HomeSlide.where(kind: HomeSlide::KIND_FEATURED_EVENT).ordered
    @top_events = HomeSlide.where(kind: HomeSlide::KIND_TOP_EVENT).ordered
    @popular_events = HomeSlide.where(kind: HomeSlide::KIND_POPULAR_EVENT).ordered

    # Main categories (line under top slider)
    @main_categories = {}
    Category.select(:id, :description).
             where(description: %w(Theater Classical Concerts)).
             each do |spec_category|
      @main_categories[spec_category.description] = spec_category.id
    end

    # Dummy of "main services"
    @main_services = [
      OpenStruct.new(name: 'Arsenal', url: '#', bg_img_url: '/content/item1.jpg'),
      OpenStruct.new(name: 'Barselona', url: '#', bg_img_url: '/content/item2.jpg'),
      OpenStruct.new(name: 'Wimbledone', url: '#', bg_img_url: '/content/item3.jpg'),
      OpenStruct.new(name: 'Tottenham', url: '#', bg_img_url: '/content/item4.jpg'),
      OpenStruct.new(name: 'French open', url: '#', bg_img_url: '/content/item5.jpg'),
      OpenStruct.new(name: 'Valencia', url: '#', bg_img_url: '/content/item6.jpg'),
      OpenStruct.new(name: 'New Year 2017', url: '#', bg_img_url: '/content/item7.jpg'),
      OpenStruct.new(name: 'Barselona', url: '#', bg_img_url: '/content/item8.jpg'),
      OpenStruct.new(name: 'Test', url: '#', bg_img_url: '/content/item9.jpg'),
      OpenStruct.new(name: 'Test', url: '#', bg_img_url: '/content/item5.jpg')
    ]

    # @sports = Event.where(sports: true).sample(3)
    # @concerts_id = Category.where(description: "Concerts").ids
    # @music = Event.where(category_id: @concerts_id).sample(3)
  end

end
