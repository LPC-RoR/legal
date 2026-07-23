class AddOcurrenciaFieldsToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :lugar_ocurrencia, :string
    add_column :krn_denuncias, :direccion_ocurrencia, :string
  end
end
