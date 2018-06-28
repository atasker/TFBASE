class OrderItem < ActiveRecord::Base
  belongs_to :order

  SHIPPING_COST = 15.0

  store :descr, accessors: [:ticket_id,
                            :event_id,
                            :event_name,
                            :category,
                            :pairs_only ], coder: JSON

  validates :order, :quantity, :price, :currency, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true,
                                       greater_than: 0 }

  def ticket_name
    "#{event_name} (category: #{category})"
  end

  def cost
    price * quantity
  end

  def fill_by_ticket(ticket)
    self.price = ticket.price
    self.currency = ticket.currency
    self.ticket_id = ticket.id
    self.event_id = ticket.event.id
    self.event_name = ticket.event.name
    self.category = ticket.category
    self.pairs_only = ticket.pairs_only
  end
end
