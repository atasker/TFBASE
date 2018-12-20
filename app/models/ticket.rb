class Ticket < ApplicationRecord

  CURRENCIES = %w(USD EUR GBP)
  DEF_FACE_VALUE = 'Not Provided' # 'Privately Owned, no face value'

  belongs_to :event
  has_many :enquiries, inverse_of: :ticket, dependent: :destroy
  has_many :cart_items, inverse_of: :ticket, dependent: :destroy

  validates :event, :category, presence: true
  validates :price,
            :quantity,
            :currency,
            presence: true, unless: Proc.new { |a| a.enquire? }
  validates :currency, inclusion: { in: CURRENCIES }, unless: Proc.new { |a| a.enquire? }
  validates :fee_percent, numericality: true, allow_blank: true

  scope :buyable, -> { where.not(enquire: true) }

  def full_name
    if persisted?
      "#{event.name} (category: #{category})"
    else
      'New ticket'
    end
  end

  def have_fee?
    fee_percent && fee_percent != 0
  end

  def amount_of_fee
    curfee = fee_percent || 0
    price * (curfee / 100)
  end

  def full_price
    price + amount_of_fee
  end

  def face_value_message
    face_value.present? ? face_value : DEF_FACE_VALUE
  end
end
