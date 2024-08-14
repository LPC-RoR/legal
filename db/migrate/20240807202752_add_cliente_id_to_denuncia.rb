class AddClienteIdToDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :denuncias, :cliente_id, :integer
    add_index :denuncias, :cliente_id
  end
end
