class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :ticket

  validates :cart, :ticket, :amount, presence: true
  validates :amount, numericality: { only_integer: true,
                                       greater_than: 0 }
end
