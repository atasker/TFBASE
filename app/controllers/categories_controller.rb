class CategoriesController < ApplicationController

  def index
    @categories = Category.order('description ASC')
  end

  def show
    @category = Category.find(params[:id])
    @players = Player.where(category_id: @category.id).order('name ASC')
    @competitions = Competition.where(category_id: @category.id).order('name ASC')
    @events = Event.where(category_id: @category.id).order('start_time ASC')
  end

end
