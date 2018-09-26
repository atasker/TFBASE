class Ticket < ApplicationRecord

  CURRENCIES = %w(USD EUR GBP)

  belongs_to :event
  has_many :enquiries, inverse_of: :ticket, dependent: :destroy
  has_many :cart_items, inverse_of: :ticket, dependent: :destroy

  validates :event, :category, presence: true
  validates :price,
            :quantity,
            :currency,
            presence: true, unless: Proc.new { |a| a.enquire? }
  validates :currency, inclusion: { in: CURRENCIES }, unless: Proc.new { |a| a.enquire? }

  scope :buyable, -> { where.not(enquire: true) }

  def full_name
    if persisted?
      "#{event.name} (category: #{category})"
    else
      'New ticket'
    end
  end
end
