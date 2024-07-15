class CreateCuestionarios < ActiveRecord::Migration[7.1]
  def change
    create_table :cuestionarios do |t|
      t.integer :orden
      t.integer :pauta_id
      t.string :cuestionario
      t.string :referencia

      t.timestamps
    end
    add_index :cuestionarios, :orden
    add_index :cuestionarios, :pauta_id
  end
end
