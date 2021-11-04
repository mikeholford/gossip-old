class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  def membership
    Membership.find_by(user_id: self.user_id, room_id: self.room_id)
  end
end
