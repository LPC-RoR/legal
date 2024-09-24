class AddCtrEtapaIdToTarea < ActiveRecord::Migration[7.1]
  def change
    add_column :tareas, :ctr_etapa_id, :integer
    add_index :tareas, :ctr_etapa_id
  end
end
