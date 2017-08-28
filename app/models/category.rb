class Category < ActiveRecord::Base
  include FriendlySlugable

  has_many :players, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :competitions, dependent: :destroy
  has_many :home_slides, inverse_of: :category, dependent: :destroy

  validates :description, presence: true,
                          length: { maximum: 50 }

  validates :sports, inclusion: { in: [true, false] }

  private

  def prepare_slug
    super description
  end
end
