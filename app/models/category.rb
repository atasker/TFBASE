class Category < ActiveRecord::Base

  has_many :players, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :competitions, dependent: :destroy

  validates :description, presence: true,
                          length: { maximum: 50 }

  validates :sports, inclusion: { in: [true, false] }

end
