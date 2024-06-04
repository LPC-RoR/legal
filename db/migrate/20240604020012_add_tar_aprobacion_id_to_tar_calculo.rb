class AddTarAprobacionIdToTarCalculo < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_calculos, :tar_aprobacion_id, :integer
    add_index :tar_calculos, :tar_aprobacion_id
  end
end
