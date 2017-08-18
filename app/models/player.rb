class Player < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader
  has_and_belongs_to_many :events
  has_many :competitions
  belongs_to :category
  has_many :home_popular_line_items, inverse_of: :player, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 50 }
  validates :category_id, presence: true

end
