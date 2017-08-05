class MessagesController < BaseFrontendController
  before_filter :add_message_breadcrumb

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

  private

  def message_params
    params.require(:message).permit(:name, :email, :body, :humanizer_answer, :humanizer_question_id)
  end

  def add_message_breadcrumb
    add_breadcrumb 'Contacts us', nil
  end

end
