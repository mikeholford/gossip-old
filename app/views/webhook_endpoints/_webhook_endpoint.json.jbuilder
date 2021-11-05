json.extract! webhook_endpoint, :id, :account_id, :url, :events, :status, :logs, :secret, :created_at, :updated_at
json.url webhook_endpoint_url(webhook_endpoint, format: :json)
