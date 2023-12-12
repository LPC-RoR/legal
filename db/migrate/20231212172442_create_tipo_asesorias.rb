class CreateTipoAsesorias < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_asesorias do |t|
      t.string :tipo_asesoria
      t.boolean :facturable
      t.boolean :documento
      t.boolean :archivos

      t.timestamps
    end
    add_index :tipo_asesorias, :tipo_asesoria
  end
end
