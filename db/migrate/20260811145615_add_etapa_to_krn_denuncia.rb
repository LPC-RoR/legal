class AddEtapaToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :etapa, :string
    add_index :krn_denuncias, :etapa
  end
end
