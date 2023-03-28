class AddTarTarifaIdToTarFormula < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_formulas, :tar_tarifa_id, :integer
    add_index :tar_formulas, :tar_tarifa_id
  end
end
