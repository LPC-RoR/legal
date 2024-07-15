class CreatePautas < ActiveRecord::Migration[7.1]
  def change
    create_table :pautas do |t|
      t.integer :orden
      t.string :pauta
      t.string :referencia

      t.timestamps
    end
    add_index :pautas, :orden
  end
end
