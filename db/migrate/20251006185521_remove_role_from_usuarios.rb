class RemoveRoleFromUsuarios < ActiveRecord::Migration[8.0]
  def change
    remove_column :usuarios, :role, :string
  end
end
