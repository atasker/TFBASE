class Order < ActiveRecord::Base

  has_one :ticket

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  # validations unfinished

end
