class Tab < ApplicationRecord
  belongs_to :tabable, polymorphic: true
end
