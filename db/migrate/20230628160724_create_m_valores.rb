class CreateMValores < ActiveRecord::Migration[5.2]
  def change
    create_table :m_valores do |t|
      t.integer :orden
      t.string :m_valor
      t.string :tipo
      t.string :valor
      t.integer :m_conciliacion_id

      t.timestamps
    end
    add_index :m_valores, :orden
    add_index :m_valores, :m_conciliacion_id
  end
end
