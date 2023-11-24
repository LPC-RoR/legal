class CreateRegiones < ActiveRecord::Migration[5.2]
  def change
    create_table :regiones do |t|
      t.string :region
      t.integer :orden

      t.timestamps
    end
    add_index :regiones, :orden
  end
end
