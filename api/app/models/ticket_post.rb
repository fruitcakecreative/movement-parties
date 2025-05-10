class TicketPost < ApplicationRecord
  belongs_to :user
  belongs_to :event
end
