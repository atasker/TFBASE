class Ticket < ActiveRecord::Base

  belongs_to :event

  validates :price, :category, :quantity, :currency, :event, presence: true

end
