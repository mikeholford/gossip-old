class AddConfigToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :config, :json, default: {}
  end
end
