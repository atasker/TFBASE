class Ticket < ActiveRecord::Base

  belongs_to :event
  has_many :enquiries, inverse_of: :ticket, dependent: :destroy

  validates :event, :category, presence: true
  validates :price,
            :quantity,
            :currency,
            presence: true, unless: 'enquire?'

  scope :buyable, -> { where.not(enquire: true) }

end
