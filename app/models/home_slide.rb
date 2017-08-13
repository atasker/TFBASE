class HomeSlide < ActiveRecord::Base
  belongs_to :event, inverse_of: :home_slides
  belongs_to :category, inverse_of: :home_slides

  mount_uploader :huge_image, HugeHomeSlideImageUploader
  mount_uploader :big_image, BigHomeSlideImageUploader
  mount_uploader :tile_image, TileHomeSlideImageUploader
  mount_uploader :avatar, AvatarUploader

  KIND_TOP_SLIDE = 0
  KIND_FEATURED_EVENT = 1
  KIND_TOP_EVENT = 2
  KIND_POPULAR_EVENT = 3

  validates :kind, presence: true

  validates :huge_image, presence: true, if: "kind == KIND_TOP_SLIDE"
  validates :avatar, presence: true, if: "kind == KIND_FEATURED_EVENT && manual_input?"
  validates :big_image, presence: true, if: "kind == KIND_TOP_EVENT"
  validates :tile_image, presence: true, if: "kind == KIND_POPULAR_EVENT"

  validates :event, presence: true, if: "!manual_input?"

  validates :title, :url, presence: true, if: :manual_input?

  scope :ordered, -> { order(prior: :asc, id: :asc) }
end
