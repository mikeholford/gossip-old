class Room < ApplicationRecord
    belongs_to :account
    has_many :messages

    has_many :memberships
    has_many :users, through: :memberships
end
