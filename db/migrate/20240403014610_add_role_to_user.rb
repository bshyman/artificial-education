# also add group_id to the User model:
class AddRoleToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string
    add_column :users, :group_id, :integer
  end
end
