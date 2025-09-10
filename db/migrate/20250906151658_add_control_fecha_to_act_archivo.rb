class AddControlFechaToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :control_fecha, :boolean
    add_index :act_archivos, :control_fecha
  end
end
