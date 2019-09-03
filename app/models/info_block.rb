class InfoBlock < ApplicationRecord
  belongs_to :info_blockable, polymorphic: true
end
