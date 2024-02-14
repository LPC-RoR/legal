class CreateAgePendientes < ActiveRecord::Migration[5.2]
  def change
    create_table :age_pendientes do |t|
      t.integer :age_usuario_id
      t.string :age_pendiente
      t.string :estado
      t.string :prioridad

      t.timestamps
    end
    add_index :age_pendientes, :age_usuario_id
  end
end
