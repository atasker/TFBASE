class Venue < ActiveRecord::Base

  mount_uploader :avatar, VenueUploader

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  has_many :events, dependent: :destroy, inverse_of: :venue
  accepts_nested_attributes_for :events, reject_if: :all_blank, allow_destroy: true
  has_many :players, through: :events

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :capacity, presence: true
  validates :address, presence: true

  validates :city, presence: true,
                   length: { maximum: 20 }

  validates :country, presence: true,
                      length: { maximum: 20 }

end
