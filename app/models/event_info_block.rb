class EventInfoBlock < ApplicationRecord
  belongs_to :event, inverse_of: :info_blocks

  validates :event, :title, presence: true

  scope :ordered, -> { order(prior: :asc, id: :asc) }
end
