class CreateMDatos < ActiveRecord::Migration[5.2]
  def change
    create_table :m_datos do |t|
      t.string :m_dato
      t.string :tipo
      t.string :formula
      t.string :split_tag
      t.integer :m_formato_id

      t.timestamps
    end
    add_index :m_datos, :m_dato
    add_index :m_datos, :tipo
    add_index :m_datos, :m_formato_id
  end
end
