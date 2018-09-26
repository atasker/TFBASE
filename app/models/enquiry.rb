class Enquiry < ApplicationRecord
  include Humanizer

  belongs_to :ticket, inverse_of: :enquiries

  require_human_on :create

  validates :ticket, presence: true
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, length: { maximum: 40 }
  validates :email, :format => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  scope :ordered, -> { order(created_at: :desc) }
end
