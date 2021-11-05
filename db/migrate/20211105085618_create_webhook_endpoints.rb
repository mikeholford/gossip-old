class CreateWebhookEndpoints < ActiveRecord::Migration[6.1]
  def change
    create_table :webhook_endpoints do |t|
      t.references :account, null: false, foreign_key: true
      t.string :url
      t.string :events
      t.string :status
      t.json :logs, default: []
      t.string :secret

      t.timestamps
    end
  end
end
