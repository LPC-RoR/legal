class AddIdentificadorToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :identificador, :string
    add_index :krn_denuncias, :identificador
  end
end
