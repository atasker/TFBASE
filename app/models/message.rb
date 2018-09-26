class Message < ApplicationRecord

  include Humanizer
  require_human_on :create

  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, length: { maximum: 40 }
  validates :email, :format => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :body, presence: true, length: { maximum: 500 }

end
