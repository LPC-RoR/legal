class AddDependenciaDenuncianteIdToDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :denuncias, :dependencia_denunciante_id, :integer
    add_index :denuncias, :dependencia_denunciante_id
  end
end
