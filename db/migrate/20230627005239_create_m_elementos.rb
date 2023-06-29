class CreateMElementos < ActiveRecord::Migration[5.2]
  def change
    create_table :m_elementos do |t|
      t.integer :orden
      t.string :m_elemento
      t.string :tipo
      t.integer :m_formato_id

      t.timestamps
    end
    add_index :m_elementos, :orden
    add_index :m_elementos, :m_elemento
    add_index :m_elementos, :tipo
    add_index :m_elementos, :m_formato_id
  end
end
