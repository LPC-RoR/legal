class AddFechaHoraDtToDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :denuncias, :fecha_hora_dt, :datetime
    add_index :denuncias, :fecha_hora_dt
  end
end
