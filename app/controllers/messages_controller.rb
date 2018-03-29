class MessagesController < BaseFrontendController
  before_filter :add_message_breadcrumb, except: [:hospitality_concierge]

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if successfully_saved = @message.save
      MessageMailer.send_email(@message).deliver
    end

    respond_to do |format|
      format.html do
        flash.now[:notice] = "Message sent!"
        render 'new'
      end
      format.json do
        if successfully_saved
          render json: { status: 'success' }, status: :created
        else
          render json: { status: 'error', errors: @message.errors.messages }
        end
      end
    end
  end

  def hospitality_concierge
    if params[:email].present? && !params[:email].match(/\A[^@]+@([^@\.]+\.)+[^@\.]+\z/).nil?
      MessageMailer.send_hospitality_concierge_email(params[:email]).deliver
      successfully_sent = true
    else
      successfully_sent = false
    end

    respond_to do |format|
      format.html do
        flash[:notice] = "Message sent!"
        redirect_to root_url
      end
      format.json do
        if successfully_sent
          render json: { status: 'success' }, status: :created
        else
          render json: { status: 'error', errors: { email: 'Wrong email' } }
        end
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :email, :body, :humanizer_answer, :humanizer_question_id)
  end

  def add_message_breadcrumb
    determine_page 'messages/new'
    @page_meta = @current_page || OpenStruct.new(title: 'Contacts us')
    add_breadcrumb (@current_page ? @current_page.title : 'Contacts us'), nil
  end

end
