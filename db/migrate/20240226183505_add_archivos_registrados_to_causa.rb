class AddArchivosRegistradosToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :archivos_registrados, :boolean
    add_index :causas, :archivos_registrados
  end
end
