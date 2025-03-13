class AddControlFechaToRepDocControlados < ActiveRecord::Migration[8.0]
  def change
    add_column :rep_doc_controlados, :control_fecha, :boolean
    add_column :rep_doc_controlados, :chequeable, :boolean
  end
end
