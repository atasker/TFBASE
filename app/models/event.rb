class Event < ApplicationRecord
  include FriendlySlugable

  acts_as_seo_carrier

  attr_accessor :seo_image
  attr_accessor :tbc

  belongs_to :venue
  belongs_to :category

  # used to be has_one, changed to enable search query on competitions, change back if anything breaks
  belongs_to :competition, optional: true
  has_and_belongs_to_many :players

  has_many :tickets, dependent: :destroy
  accepts_nested_attributes_for :tickets, reject_if: :all_blank,
                                          allow_destroy: true
  has_many :home_slides, inverse_of: :event, dependent: :destroy
  has_many :info_blocks, class_name: 'EventInfoBlock',
                         inverse_of: :event,
                         dependent: :destroy
  accepts_nested_attributes_for :info_blocks, reject_if: :all_blank,
                                              allow_destroy: true

  validates :name, presence: true,
                   length: { maximum: 70 }
  validates :venue_id, presence: true
  validates :category_id, presence: true
  validates :sports, inclusion: { in: [true, false] }
  validates :priority, inclusion: { in: [true, false] }

  after_initialize :set_tbc_attribute
  before_save :check_tbc_attribute
  after_create :check_slug_generation

  include PgSearch
  pg_search_scope :search, :against => :name, ignoring: :accents,
    using: {tsearch: {dictionary: "english"}},
    associated_against: {
      venue: [:name, :city],
      category: :description,
      competition: :name,
      players: :name
    }

  scope :actual, -> { where('(events.start_time >= ? OR events.start_time IS NULL)', DateTime.now) }

  def title; name end

  def tbc?
    persisted? && start_time.nil?
  end

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  private

  # After initialize set value of TBC (to be confirmed) attribute.
  # TBC helps to set start_date to nil in editing
  def set_tbc_attribute
    self.tbc = tbc? ? '1' : '0'
  end
  # Before save checking TBC attribute to drop start_date if it is necessary
  def check_tbc_attribute
    self.start_time = nil if tbc == '1'
  end

  # Event auto-generated slug must use name and id: "event-name-3532" as example
  # but new object has no id and get it only after save.
  # So we need to regenerate slug and resave object after create if we have no
  # user inputed slug.
  def prepare_slug
    if new_record? && slug.blank?
      @reassemble_slug_after_create = true
      super("#{name.to_s.strip}-#{SecureRandom.uuid}")
    else
      super("#{name.to_s.strip}-#{id}")
    end
  end

  def check_slug_generation
    if @reassemble_slug_after_create == true
      self.slug = nil
      prepare_slug
      save
    end
  end
end
