class Room < ApplicationRecord
    belongs_to :account
    has_many :messages

    has_many :memberships
    has_many :users, through: :memberships

    def membership_for(user_id)
        return memberships.find_by(user_id: user_id)
    end
end
