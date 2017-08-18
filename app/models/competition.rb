class Competition < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader
  has_many :players
  belongs_to :category
  has_many :events, dependent: :destroy

  has_many :home_popular_line_items, inverse_of: :competition, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :category_id, presence: true

end
