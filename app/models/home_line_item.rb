class HomeLineItem < ActiveRecord::Base
  belongs_to :competition, inverse_of: :home_line_items
  belongs_to :player, inverse_of: :home_line_items

  mount_uploader :avatar, AvatarUploader

  KIND_MANUAL = 0
  KIND_COMPETITION = 1
  KIND_PLAYER = 2

  validates :kind, inclusion: { in: [KIND_MANUAL, KIND_COMPETITION, KIND_PLAYER] }
  validates :title, :url, :avatar, presence: true, if: "kind == HomeLineItem::KIND_MANUAL"
  validates :competition, presence: true, if: "kind == HomeLineItem::KIND_COMPETITION"
  validates :player, presence: true, if: "kind == HomeLineItem::KIND_PLAYER"

  before_save :clean_unused_fields

  scope :ordered, -> { order(prior: :asc, id: :asc) }

  def view_title
    case kind
    when KIND_MANUAL then title
    when KIND_COMPETITION then competition.name
    when KIND_PLAYER then player.name
    end
  end

  def image
    case kind
    when KIND_MANUAL then avatar
    when KIND_COMPETITION then competition.avatar
    when KIND_PLAYER then player.avatar
    end
  end

  private

  # before save
  def clean_unused_fields
    if kind != KIND_MANUAL
      self.title = nil unless title.nil?
      self.url = nil unless url.nil?
      remove_avatar! if avatar.present?
    end
    if kind != KIND_COMPETITION
      self.competition = nil unless competition.nil?
    end
    if kind != KIND_PLAYER
      self.player = nil unless player.nil?
    end
  end
end
