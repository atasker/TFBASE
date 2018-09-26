class Player < ApplicationRecord
  include FriendlySlugable

  acts_as_seo_carrier

  mount_uploader :avatar, AvatarUploader
  has_and_belongs_to_many :events
  belongs_to :category
  has_many :home_line_items, inverse_of: :player, dependent: :destroy

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
