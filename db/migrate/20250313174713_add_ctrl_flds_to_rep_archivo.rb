class AddCtrlFldsToRepArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :rep_archivos, :control_fecha, :boolean
    add_column :rep_archivos, :chequeable, :boolean
    add_column :rep_archivos, :chck, :boolean
    add_column :rep_archivos, :fecha, :datetime
  end
end
