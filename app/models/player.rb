class Player < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader
  has_and_belongs_to_many :events
  has_many :competitions
  has_one :category

  validates :name, presence: true,
                   length: { maximum: 50 }
  validates :category_id, presence: true

end
