class SendWebhookJob < ApplicationJob
  queue_as :default

  MAX_RETRIES = 10

endpoint = "https://uh.ngrok.io/api/v1/messages/gossip"
data = {data:{id: "xxx", user_id: 3, room_id: 10, category: 'text', body: "HELLO" }}


  def perform(endpoint, data, retry_count=0)

    # return if cancelled?

    digest = OpenSSL::Digest.new('sha256')
    signature = OpenSSL::HMAC.digest(digest, endpoint.secret, data.to_json)
    sig_header = Base64.encode64(signature).strip()

    # Make request
    begin
      response = HTTP.headers(gossip_signature: sig_header).post(endpoint.url, json: data)
      successful = (response&.code == 200 && response.present? )
    rescue StandardError => e
      endpoint.record_log(:error, response&.code, data[:object], "#{e.message} | Retry: #{retry_count}", data)
      successful = false
    end

    if successful
      endpoint.record_log(:info, response&.code, data[:object], "Successful", data)
    elsif retry_count < MAX_RETRIES
      endpoint.record_log(:error, response&.code, data[:object], "Error | Retry: #{retry_count}", data)
      wait = 2 ** retry_count
      SendWebhookJob.set(wait: wait.minutes).perform_later(endpoint, data, retry_count + 1)
      if retry_count == 3 # Send a notification to developer
        puts "Failed to send webhook!!! Trying again..."
        # AdminService.new.error("⚠️ WebhookDeliveryError ⚠️\n\nRetry #: #{retry_count}\nEndpoint: #{endpoint.url}\n\nData: #{data}")
        # OrganisationMailer.webhook_delivery_error(endpoint.organisation, endpoint.url, retry_count, data).deliver_later 
      end
    elsif retry_count >= MAX_RETRIES
        puts "Completely failed to send webhook!!!"
    #   AdminService.new.error("❌ WebhookDeliveryFailed ❌\n\nRetry #: #{retry_count}\nEndpoint: #{endpoint.url}\n\nData: #{data}")
    #   OrganisationMailer.webhook_delivery_failed(endpoint.organisation, endpoint.url, retry_count, data).deliver_later
    end
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists?("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

end
