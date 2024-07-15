class CreateHmNotas < ActiveRecord::Migration[7.1]
  def change
    create_table :hm_notas do |t|
      t.integer :hm_parrafo_id
      t.integer :orden
      t.string :hm_nota

      t.timestamps
    end
    add_index :hm_notas, :hm_parrafo_id
    add_index :hm_notas, :orden
  end
end
