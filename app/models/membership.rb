class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :room
  enum role: [:regular, :api]
end
