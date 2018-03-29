class PagesController < BaseFrontendController
  def show
    determine_page

    if @current_page.nil?
      raise ActiveRecord::RecordNotFound, "Record not found"
    else
      @page_meta = @current_page
      add_breadcrumb @current_page.title, nil

      respond_to do |format|
        format.html
        # format.json  { render json: @current_page }
      end
    end
  end

  def about
    determine_page
    @page_meta = @current_page || OpenStruct.new(title: 'About us')
    add_breadcrumb (@current_page ? @current_page.title : 'About us'), nil

    respond_to do |format|
      format.html
    end
  end

  def sport
    @sport_categories = Category.where(sports: true).order('description ASC')

    determine_page
    @page_meta = @current_page || OpenStruct.new(title: 'Sport')
    add_breadcrumb 'Categories', categories_path
    add_breadcrumb (@current_page ? @current_page.title : 'Sport'), nil

    respond_to do |format|
      format.html
    end
  end
end
