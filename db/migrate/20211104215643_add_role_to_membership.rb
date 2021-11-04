class AddRoleToMembership < ActiveRecord::Migration[6.1]
  def change
    add_column :memberships, :role, :integer, default: 0
  end
end
