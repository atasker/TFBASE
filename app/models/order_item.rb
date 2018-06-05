class OrderItem < ActiveRecord::Base
  belongs_to :order

  store :descr, accessors: [:ticket_id,
                            :event_id,
                            :event_name,
                            :category,
                            :pairs_only ], coder: JSON

  validates :order, :quantity, :price, :currency, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true,
                                       greater_than: 0 }
end
