class OrdersMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def order_created_message_to_user(order)
    return nil unless order.user
    @order = order
    @user = @order.user
    mail(to: order.user.email, subject: "Order ##{@order.id} was successfully created on Ticketfinders")
  end
end
