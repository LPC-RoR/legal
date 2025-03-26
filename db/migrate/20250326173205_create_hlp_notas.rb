class CreateHlpNotas < ActiveRecord::Migration[8.0]
  def change
    create_table :hlp_notas do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.integer :orden
      t.string :hlp_nota
      t.string :texto
      t.string :referencia

      t.timestamps
    end
    add_index :hlp_notas, :ownr_type
    add_index :hlp_notas, :ownr_id
    add_index :hlp_notas, :orden
  end
end
