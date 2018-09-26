class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :nullify

  has_and_belongs_to_many :categories_not_for_email_notifications,
    class_name: 'Category',
    join_table: 'users_categories_email_notifications',
    foreign_key: "user_id",
    association_foreign_key: "category_id"

  validates :name, presence: true
  # validates :agree_email,
  #   inclusion: {
  #     in: ['1', 'true', true],
  #     message: 'must be accepted or you can\'t finish sign up process' },
  #   on: :create

  def display_name
    name.present? ? name : email
  end
end
