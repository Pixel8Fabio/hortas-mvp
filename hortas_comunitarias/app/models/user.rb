class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { community_member: 0, garden_manager: 1, admin: 2 }

  has_many :gardens, dependent: :destroy

  validates :name, presence: true
end
