class CreateStLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :st_logs do |t|
      t.integer :perfil_id
      t.string :class_name
      t.integer :objeto_id
      t.string :e_origen
      t.string :e_destino

      t.timestamps
    end
    add_index :st_logs, :perfil_id
    add_index :st_logs, :objeto_id
    add_index :st_logs, :e_origen
    add_index :st_logs, :e_destino
  end
end
