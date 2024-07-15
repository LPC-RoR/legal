class CreateRespuestas < ActiveRecord::Migration[7.1]
  def change
    create_table :respuestas do |t|
      t.integer :campania_id
      t.integer :k_sesion_id
      t.string :respuesta
      t.string :propuesta

      t.timestamps
    end
    add_index :respuestas, :campania_id
    add_index :respuestas, :k_sesion_id
  end
end
