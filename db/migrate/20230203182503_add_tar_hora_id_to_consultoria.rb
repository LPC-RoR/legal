class AddTarHoraIdToConsultoria < ActiveRecord::Migration[5.2]
  def change
    add_column :consultorias, :tar_hora_id, :integer
    add_index :consultorias, :tar_hora_id
  end
end
