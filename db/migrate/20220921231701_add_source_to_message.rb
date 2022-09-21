class AddSourceToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :source, :integer, default: 0
  end
end
