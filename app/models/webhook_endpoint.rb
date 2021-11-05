class WebhookEndpoint < ApplicationRecord
  serialize :events

  belongs_to :account

  after_create :set_secret

  scope :live, -> { where(status: 'live') }

  def record_log(level, code, event, msg, data)
    logs = self.logs || []
    logs = logs.unshift({
      time: Time.now.utc, 
      level: level.to_s, 
      code: code,
      event: event, 
      message: msg, 
      data: data
    }).slice!(0...100)
    self.update(logs: logs)
  end

  private

  def set_secret
    self.update(secret: "goss_#{SecureRandom.hex(12)}") unless secret.present?
  end

end
