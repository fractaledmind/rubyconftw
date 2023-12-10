class User < ApplicationRecord
  validates :screen_name, presence: true, uniqueness: true
end
