# frozen_string_literal: true

class Users::ProfileController < BaseFrontendController
  before_action :authenticate_user!

  before_action :add_users_breadcrumb

  def show

  end

  private

  def add_users_breadcrumb
    add_breadcrumb 'User', ''
  end
end
