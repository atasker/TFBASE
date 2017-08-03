class HomeController < BaseFrontendController

  def index
    @is_homepage = true

    # This is dummy slides for top slider on homepage.
    # Better to replace it with real objects, managable from admin.
    # But for first time it's ok to just enter valid data.
    @top_slides = [
      OpenStruct.new(
        title: 'Cirque du Soleil Amaluna',
        place: 'London, UK',
        bg_img_url: '/content/main1.jpg',
        start_date: Date.new(2017, 1, 12),
        end_date: Date.new(2017, 2, 14),
        event_url: '#'
      ),
      OpenStruct.new(
        title: 'Test 1',
        place: 'test, OK',
        bg_img_url: '/content/main1.jpg',
        start_date: Date.new(2017, 2, 14),
        end_date: nil,
        event_url: '#'
      ),
      OpenStruct.new(
        title: 'Test 1',
        place: 'London, UK',
        bg_img_url: '/content/main1.jpg',
        start_date: Date.new(2017, 1, 12),
        end_date: nil,
        event_url: '#'
      )
    ]

    # Main categories (line under top slider)
    @main_categories = {}
    Category.select(:id, :description).
             where(description: %w(Theater Classical Concerts)).
             each do |spec_category|
      @main_categories[spec_category.description] = spec_category.id
    end

    # @sports = Event.where(sports: true).sample(3)
    # @concerts_id = Category.where(description: "Concerts").ids
    # @music = Event.where(category_id: @concerts_id).sample(3)
  end

end
