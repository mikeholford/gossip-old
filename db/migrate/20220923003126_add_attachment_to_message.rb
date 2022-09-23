class AddAttachmentToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :attachment, :string
  end
end
