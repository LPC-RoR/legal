class DropComFiles < ActiveRecord::Migration[8.0]
  def change
    drop_table :com_requerimientos
    drop_table :com_documentos
  end
end