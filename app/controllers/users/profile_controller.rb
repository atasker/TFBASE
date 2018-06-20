# frozen_string_literal: true

class Users::ProfileController < BaseFrontendController
  before_action :authenticate_user!

  before_action :add_users_breadcrumb

  def show
    @orders = current_user.orders.includes(:items).order(created_at: :desc).limit(6)
    @have_more_orders = current_user.orders.count > 6
  end

  private

  def add_users_breadcrumb
    add_breadcrumb 'User', ''
  end
end
