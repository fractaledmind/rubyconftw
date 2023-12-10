class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  validates :screen_name, presence: true, uniqueness: true
end
