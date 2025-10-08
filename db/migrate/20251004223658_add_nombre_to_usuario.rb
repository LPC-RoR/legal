class AddNombreToUsuario < ActiveRecord::Migration[8.0]
  def change
    add_column :usuarios, :nombre, :string
  end
end
