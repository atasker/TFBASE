# frozen_string_literal: true

class Users::OrdersController < BaseFrontendController
  before_action :authenticate_user!

  def index
    add_breadcrumb 'User', user_profile_path
    add_breadcrumb 'Orders', ''

    @orders = current_user.orders.includes(:items).order(created_at: :desc)
  end
end
