class CreateDemandantes < ActiveRecord::Migration[7.1]
  def change
    create_table :demandantes do |t|
      t.integer :causa_id
      t.integer :orden
      t.string :nombres
      t.string :apellidos
      t.decimal :remuneracion
      t.string :cargo
      t.string :lugar_trabajo

      t.timestamps
    end
    add_index :demandantes, :causa_id
    add_index :demandantes, :orden
  end
end
