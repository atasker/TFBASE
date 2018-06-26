class EnquiriesController < BaseFrontendController
  def create
    @enquiry = Enquiry.new(enquiry_params)

    if successfully_saved = @enquiry.save
      MessageMailer.send_ticket_enquiry(@enquiry).deliver
      MessageMailer.send_ticket_enquiry_to_client(@enquiry).deliver
    end

    respond_to do |format|
      format.html do
        flash.now[:notice] = "Enquiry sent!"
        render 'new'
      end
      format.json do
        if successfully_saved
          render json: { status: 'success' }, status: :created
        else
          render json: { status: 'error', errors: @enquiry.errors.messages }
        end
      end
    end
  end

  private

  def enquiry_params
    params.require(:enquiry).permit(:ticket_id, :name, :email, :body, :humanizer_answer, :humanizer_question_id)
  end

end
