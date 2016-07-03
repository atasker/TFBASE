class StaticController < ApplicationController

  def sport
    @categories = Category.where(sports: true)
  end

  def terms
  end

  def about
  end

end
