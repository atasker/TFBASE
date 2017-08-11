Rails.application.routes.draw do

  post '/messages/hospitality-and-concierge',
    to: 'messages#hospitality_concierge',
    as: :hospitality_concierge
  resources :messages, only: [:new, :create]

  get 'static/sport'
  get 'static/terms'
  get 'static/about'

  resources :categories, only: [:show, :index]
  resources :competitions, only: [:show, :index]
  resources :events, only: [:show, :index]
  resources :players, only: [:show]
  resources :tickets, only: [:show]

  root 'home#index'

  namespace :admin do
    root 'welcome#index'
    resources :categories
    resources :competitions
    resources :events
    resources :players
    resources :tickets
    resources :venues
  end

end
