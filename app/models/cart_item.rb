class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :ticket

  validates :cart, :ticket, :quantity, presence: true
  validates :quantity, numericality: { only_integer: true,
                                       greater_than: 0 }
end
