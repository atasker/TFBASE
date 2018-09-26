class Competition < ApplicationRecord
  include FriendlySlugable

  acts_as_seo_carrier

  belongs_to :category
  has_many :events, dependent: :destroy

  has_many :home_line_items, inverse_of: :competition, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :category_id, presence: true

  def title; name end

  def seo_image; avatar.grid_large.url end

  private

  def prepare_slug
    super name
  end
end
