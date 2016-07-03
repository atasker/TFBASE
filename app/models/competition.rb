class Competition < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader
  has_many :players
  has_one :category
  has_many :events, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :category_id, presence: true

end
