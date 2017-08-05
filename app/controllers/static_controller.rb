class StaticController < BaseFrontendController

  def sport
    @sport_categories = Category.where(sports: true).order('description ASC')
    add_breadcrumb 'Categories', categories_path
    add_breadcrumb 'Sport', nil
  end

  def terms
    add_breadcrumb 'Terms', nil
  end

  def about
    add_breadcrumb 'About us', nil
  end

end
