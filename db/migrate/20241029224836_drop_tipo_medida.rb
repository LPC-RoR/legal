class DropTipoMedida < ActiveRecord::Migration[7.1]
  def change
    drop_table :krn_tipo_medidas
  end
end
