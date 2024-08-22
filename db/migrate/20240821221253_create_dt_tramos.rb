class CreateDtTramos < ActiveRecord::Migration[7.1]
  def change
    create_table :dt_tramos do |t|
      t.string :dt_tramo
      t.integer :orden
      t.decimal :min
      t.decimal :max

      t.timestamps
    end
    add_index :dt_tramos, :orden
  end
end
