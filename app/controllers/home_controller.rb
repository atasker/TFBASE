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
        end_date: Date.new(2017, 2, 4),
        event_url: '#'
      ),
      OpenStruct.new(
        title: 'Test 1',
        place: 'test, OK',
        bg_img_url: '/content/main1.jpg',
        start_date: Date.new(2017, 2, 4),
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

    # Dummy of feature slides
    @featured_slides = [
      OpenStruct.new(
        title: 'Kentucky Derby Tickets',
        place: 'Barcelona, Spain',
        start_date: Date.new(2017, 12, 14),
        end_date: nil,
        bg_img_url: '/content/f-test1.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Horse Racing', url: '#', sqheme_color: 'green'),
          OpenStruct.new(name: 'Special Events', url: '#', sqheme_color: 'yellow')
        ]
      ),
      OpenStruct.new(
        title: 'Champions League 2016/17 Tickets',
        place: 'Leverkusen, Germany',
        start_date: Date.new(2017, 12, 14),
        end_date: Date.new(2018, 2, 28),
        bg_img_url: '/content/f-test2.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Football', url: '#', sqheme_color: 'green')
        ]
      ),
      OpenStruct.new(
        title: "London's West End Musical Theatre Tickets",
        place: 'Moscow, Russia',
        start_date: Date.new(2018, 2, 28),
        end_date: nil,
        bg_img_url: '/content/f-test3.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Horse Racing', url: '#', sqheme_color: 'green'),
          OpenStruct.new(name: 'Special Events', url: '#', sqheme_color: 'yellow')
        ]
      ),
      OpenStruct.new(
        title: 'Formula 1 Tickets',
        place: 'Barcelona, Spain',
        start_date: nil,
        end_date: nil,
        bg_img_url: '/content/f-test4.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Motor Racing', url: '#', sqheme_color: 'green')
        ]
      ),
      OpenStruct.new(
        title: 'Kentucky Derby Tickets',
        place: 'Barcelona, Spain',
        start_date: Date.new(2017, 12, 14),
        end_date: Date.new(2018, 2, 28),
        bg_img_url: '/content/f-test2.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Horse Racing', url: '#', sqheme_color: 'green'),
          OpenStruct.new(name: 'Special Events', url: '#', sqheme_color: 'yellow')
        ]
      )
    ]

    # Dummy of "top events"
    @top_events = [
      OpenStruct.new(
        title: 'Champions League 2016/17 Tickets',
        place: 'Yas Marina, Abu Dhabi',
        start_date: Date.new(2017, 12, 14),
        end_date: Date.new(2018, 2, 28),
        bg_img_url: '/content/m-test1.jpg',
        url: '#',
        label: 'Test'
      ),
      OpenStruct.new(
        title: 'Champions League 2016/17 Tickets',
        place: 'Yas Marina, Abu Dhabi',
        start_date: Date.new(2017, 12, 14),
        end_date: nil,
        bg_img_url: '/content/m-test2.jpg',
        url: '#',
        label: 'Motor racing'
      ),
      OpenStruct.new(
        title: 'Champions League 2016/17 Tickets',
        place: 'Yas Marina, Abu Dhabi',
        start_date: Date.new(2018, 2, 28),
        end_date: nil,
        bg_img_url: '/content/m-test3.jpg',
        url: '#',
        label: 'Motor racing'
      ),
      OpenStruct.new(
        title: 'Champions League 2016/17 Tickets',
        place: 'Yas Marina, Abu Dhabi',
        start_date: Date.new(2017, 12, 14),
        end_date: Date.new(2018, 2, 28),
        bg_img_url: '/content/m-test4.jpg',
        url: '#',
        label: 'test'
      )
    ]

    # Dummy of "popular events"
    @popular_events = [
      OpenStruct.new(
        title: 'Champions League 2016/17 Tickets',
        place: 'Barcelona, Spain',
        start_date: Date.new(2017, 12, 14),
        end_date: Date.new(2018, 2, 28),
        bg_img_url: '/content/p-test1.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Golf', url: '#', sqheme_color: 'green'),
          OpenStruct.new(name: 'Special Events', url: '#', sqheme_color: 'yellow')
        ]
      ),
      OpenStruct.new(
        title: 'The British Open 2017 Tickets',
        place: 'Barcelona, Spain',
        start_date: Date.new(2018, 2, 28),
        end_date: nil,
        bg_img_url: '/content/p-test2.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Motorcycling', url: '#', sqheme_color: 'green')
        ]
      ),
      OpenStruct.new(
        title: 'Champions League 2016/17 Tickets',
        place: 'Barcelona, Spain',
        start_date: Date.new(2018, 2, 28),
        end_date: nil,
        bg_img_url: '/content/p-test1.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Golf', url: '#', sqheme_color: 'green'),
          OpenStruct.new(name: 'Special Events', url: '#', sqheme_color: 'yellow')
        ]
      ),
      OpenStruct.new(
        title: 'The British Open 2017 Tickets',
        place: 'Barcelona, Spain',
        start_date: Date.new(2017, 12, 14),
        end_date: Date.new(2018, 2, 28),
        bg_img_url: '/content/p-test2.jpg',
        url: '#',
        labels: [
          OpenStruct.new(name: 'Motorcycling', url: '#', sqheme_color: 'green')
        ]
      )
    ]

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
