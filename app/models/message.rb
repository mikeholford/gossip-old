class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates_presence_of :body

  def membership
    Membership.find_by(user_id: self.user_id, room_id: self.room_id)
  end

  def send_webhook(kind)
    acc = self.room.account
    endpoints = acc.webhook_endpoints.live.select{ |e| e.events.include?("#{kind}") }
    endpoints.each do |e|
      SendWebhookJob.perform_later(e, {
        id: "evt_#{SecureRandom.hex(12)}",
        object: "#{kind}",
        data: {
          id: self.id,
          user_id: self.user.id,
          room_id: self.room.id,
          category: 'text',
          body: self.body,
          created_at: self.created_at.to_s,
          updated_at: self.updated_at.to_s
        }
      })
    end
  end

end
