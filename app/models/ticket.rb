class Ticket < ActiveRecord::Base

  belongs_to :event

  validates :price, presence: true
  validates :category, presence: true
  validates :quantity, presence: true
  validates :event_id, presence: true
  validates :currency, presence: true

end
