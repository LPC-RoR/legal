class ArreglaDeleteAllRepArchivo < ActiveRecord::Migration[8.0]
  def change
    change_column_null :rep_archivos, :ownr_type, true
    change_column_null :rep_archivos, :ownr_id,   true
  end
end
