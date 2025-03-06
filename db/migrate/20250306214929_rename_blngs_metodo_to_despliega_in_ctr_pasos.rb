class RenameBlngsMetodoToDespliegaInCtrPasos < ActiveRecord::Migration[8.0]
  def change
    rename_column :ctr_pasos, :blngs_metodo, :despliega
  end
end
