class Order < ActiveRecord::Base
  belongs_to :user
  has_many :items, class_name: 'OrderItem', dependent: :destroy

  # deprecated
  # has_one :ticket
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :email, presence: true
  # validates :phone, presence: true
  # validations unfinished
end
