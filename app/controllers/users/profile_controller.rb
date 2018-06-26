# frozen_string_literal: true

class Users::ProfileController < BaseFrontendController
  before_action :authenticate_user!

  def show
    add_breadcrumb 'User', ''
    @orders = current_user.orders.includes(:items).order(created_at: :desc).limit(6)
    @have_more_orders = current_user.orders.count > 6
  end

  def email_settings
    prepare_email_settings_data
  end

  def email_settings_update
    prepare_email_settings_data

    ep_params = email_preferences_params
    eml_categ_ids = ep_params.delete(:emailing_categories)

    if @user.update(ep_params)
      @user.categories_for_email_notification_ids = eml_categ_ids
      flash[:notice] = "Email preferences successfully updated"
      redirect_to action: :show
    else
      render 'email_settings'
    end
  end

  private

  def prepare_email_settings_data
    add_breadcrumb 'User', user_profile_path
    add_breadcrumb 'Email Preferences', ''

    @user = current_user
    @emailing_category_ids = @user.categories_for_email_notifications.pluck('id')
  end

  def email_preferences_params
    params.require(:user).permit(:agree_email, emailing_categories: [])
  end
end
