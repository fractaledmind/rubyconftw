class Session < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: { message: "must exist" }

  def browser = @browser ||= Browser.new(user_agent)
end
