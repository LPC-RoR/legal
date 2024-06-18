class CreateNotas < ActiveRecord::Migration[7.1]
  def change
    create_table :notas do |t|
      t.string :ownr_clss
      t.integer :ownr_id
      t.integer :perfil_id
      t.string :nota
      t.string :prioridad
      t.boolean :realizado

      t.timestamps
    end
    add_index :notas, :ownr_clss
    add_index :notas, :ownr_id
    add_index :notas, :perfil_id
  end
end
