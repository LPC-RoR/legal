class CreateHechoArchivos < ActiveRecord::Migration[5.2]
  def change
    create_table :hecho_archivos do |t|
      t.integer :hecho_id
      t.integer :app_archivo_id
      t.string :establece
      t.integer :orden

      t.timestamps
    end
    add_index :hecho_archivos, :hecho_id
    add_index :hecho_archivos, :app_archivo_id
    add_index :hecho_archivos, :establece
    add_index :hecho_archivos, :orden
  end
end
