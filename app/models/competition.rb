class Competition < ApplicationRecord
  include FriendlySlugable

  acts_as_seo_carrier

  belongs_to :category
  has_many :events, dependent: :destroy

  has_many :home_line_items, inverse_of: :competition, dependent: :destroy
  has_many :info_blocks, as: :info_blockable, dependent: :destroy, inverse_of: :info_blockable
  accepts_nested_attributes_for :info_blocks, reject_if: :all_blank, allow_destroy: true

  mount_uploader :avatar, AvatarUploader

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :category_id, presence: true

  include PgSearch
  pg_search_scope :search_starts_with,
                  against: :name,
                  using: {tsearch: { prefix: true }}

  def title; name end

  def seo_image; avatar.grid_large.url end

  private

  def prepare_slug
    super name
  end
end
