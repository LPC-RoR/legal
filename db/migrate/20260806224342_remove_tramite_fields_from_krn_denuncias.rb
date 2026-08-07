class RemoveTramiteFieldsFromKrnDenuncias < ActiveRecord::Migration[8.0]
  def change
    remove_column :krn_denuncias, :fecha_informe_inicio_investigacion, :date
    remove_column :krn_denuncias, :fecha_deposito_informe, :date
  end
end
