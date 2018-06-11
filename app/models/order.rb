class Order < ActiveRecord::Base
  belongs_to :user
  has_many :items, class_name: 'OrderItem', dependent: :destroy

  validates :guid, :currency, presence: true

  before_validation :process_guid

  def sum
    items.inject(0) { |sum, item| sum + item.price * item.quantity }
  end

  private

  # Generate new guid if the field is blank.
  # @private
  def process_guid
    self.guid = SecureRandom.hex(20) if guid.blank?
  end
end
