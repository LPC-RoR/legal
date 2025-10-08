class AddRoleToUsuario < ActiveRecord::Migration[8.0]
  def change
    add_column :usuarios, :role, :string
  end
end
