class CreateCausaArchivos < ActiveRecord::Migration[5.2]
  def change
    create_table :causa_archivos do |t|
      t.integer :causa_id
      t.integer :app_archivo_id
      t.integer :orden
      t.boolean :seleccionado

      t.timestamps
    end
    add_index :causa_archivos, :causa_id
    add_index :causa_archivos, :app_archivo_id
    add_index :causa_archivos, :orden
    add_index :causa_archivos, :seleccionado
  end
end
