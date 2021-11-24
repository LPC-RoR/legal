class CreateConsultorias < ActiveRecord::Migration[5.2]
  def change
    create_table :consultorias do |t|
      t.string :consultoria
      t.integer :cliente_id
      t.string :estado
      t.integer :tar_tarea_id

      t.timestamps
    end
    add_index :consultorias, :cliente_id
    add_index :consultorias, :tar_tarea_id
  end
end
