class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum status: { interested: 0, attending: 1 }
end
