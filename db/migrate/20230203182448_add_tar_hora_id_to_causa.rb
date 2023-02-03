class AddTarHoraIdToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :tar_hora_id, :integer
    add_index :causas, :tar_hora_id
  end
end
