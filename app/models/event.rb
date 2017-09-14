class Event < ActiveRecord::Base
  include FriendlySlugable

  belongs_to :venue
  belongs_to :category

  # used to be has_one, changed to enable search query on competitions, change back if anything breaks
  belongs_to :competition

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
  validates :start_time, presence: true
  validates :venue_id, presence: true
  validates :category_id, presence: true
  validates :sports, inclusion: { in: [true, false] }
  validates :priority, inclusion: { in: [true, false] }

  after_create :check_slug_generation

  include PgSearch
  pg_search_scope :search, :against => :name,
    using: {tsearch: {dictionary: "english"}},
    associated_against: {
      venue: [:name, :city],
      category: :description,
      competition: :name
    }

  scope :actual, -> { where('events.start_time >= ?', DateTime.now) }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  private

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
