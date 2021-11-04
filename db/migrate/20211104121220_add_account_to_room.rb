class AddAccountToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :account_id, :integer
  end
end
