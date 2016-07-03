class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      MessageMailer.send_email(@message).deliver
      flash.now[:notice] = "Message sent!"
      render 'new'
    else
      render 'new'
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :email, :body, :humanizer_answer, :humanizer_question_id)
  end

end
