Rails.application.routes.draw do

  namespace :admin do
    root 'welcome#index'
    resources :categories
    resources :competitions
    resources :events
    resources :players
    resources :tickets
    resources :venues
    resources :pages
    resources :users
    resources :orders, only: [:index, :show]
    scope '/homepage/' do
      resources :home_line_items
      get '/', to: redirect('/admin')
    end
  end

  scope '/admin/homepage/:slides_kind' do
    get '/', to: 'admin/home_slides#index', as: :admin_home_slides
    post '/', to: 'admin/home_slides#create'
    get 'new', to: 'admin/home_slides#new', as: :new_admin_home_slide
    get ':id/edit', to: 'admin/home_slides#edit', as: :edit_admin_home_slide
    get ':id', to: 'admin/home_slides#show', as: :admin_home_slide
    patch ':id', to: 'admin/home_slides#update'
    put ':id', to: 'admin/home_slides#update'
    delete ':id', to: 'admin/home_slides#destroy'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  match 'orders/apply-by/:cart_id', to: 'orders#apply_by_cart_id_after_paypal_payment',
                                    via: [:get, :post],
                                    as: :apply_order_by_cart
  get 'orders/:guid', to: 'orders#show', as: :order

  get 'cart/clear', to: 'cart#clear', as: :clear_cart
  get 'cart/remove', to: 'cart#remove', as: :remove_from_cart
  get 'cart/sub', to: 'cart#sub', as: :sub_from_cart
  get 'cart/add', to: 'cart#add', as: :add_to_cart
  get 'cart', to: 'cart#show', as: :cart

  post '/messages/hospitality-and-concierge',
    to: 'messages#hospitality_concierge',
    as: :hospitality_concierge
  resources :messages, only: [:new, :create]

  post '/enquiry-ticket', to: 'enquiries#create', as: :create_enquiry

  get '/competitions/:compet/:id', to: 'players#show', as: :competition_player
  resources :categories, only: [:show, :index]
  resources :competitions, only: [:show, :index]
  resources :events, only: [:show, :index]
  resources :players, only: [:show]
  resources :tickets, only: [:show]

  get 'static/about', to: 'pages#about'
  get 'static/sport', to: 'pages#sport'
  get '*page_path', to: 'pages#show', as: :page

  root 'home#index'
end
