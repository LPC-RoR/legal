class CreateAsesorias < ActiveRecord::Migration[5.2]
  def change
    create_table :asesorias do |t|
      t.integer :cliente_id
      t.integer :tar_servicio_id
      t.string :descripcion
      t.text :detalle
      t.datetime :fecha
      t.datetime :plazo

      t.timestamps
    end
    add_index :asesorias, :cliente_id
    add_index :asesorias, :tar_servicio_id
  end
end
