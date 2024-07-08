class AddFechaAudienciaToCausa < ActiveRecord::Migration[7.1]
  def change
    add_column :causas, :fecha_audiencia, :datetime
    add_index :causas, :fecha_audiencia
  end
end
