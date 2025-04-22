class DropCtrFiles < ActiveRecord::Migration[8.0]
  def change
    drop_table :ctr_registros
    drop_table :ctr_pasos
  end
end
