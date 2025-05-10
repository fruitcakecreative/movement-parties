class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  before_validation { self.status ||= "pending" }

  validates :user_id, uniqueness: { scope: :friend_id }
end
