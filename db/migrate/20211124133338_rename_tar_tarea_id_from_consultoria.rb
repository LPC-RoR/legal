class RenameTarTareaIdFromConsultoria < ActiveRecord::Migration[5.2]
  def change
  	rename_column :consultorias, 'tar_tarea_id', 'tar_tarifa_id'
  end
end
