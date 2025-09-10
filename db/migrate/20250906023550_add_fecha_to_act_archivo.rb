class AddFechaToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :fecha, :date
  end
end
