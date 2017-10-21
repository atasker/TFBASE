class Ticket < ActiveRecord::Base

  belongs_to :event

  validates :event, :category, presence: true
  validates :price,
            :quantity,
            :currency,
            presence: true, unless: 'enquire?'

  scope :buyable, -> { where.not(enquire: true) }

end
