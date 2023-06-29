class CreateMFormatos < ActiveRecord::Migration[5.2]
  def change
    create_table :m_formatos do |t|
      t.string :m_formato
      t.integer :m_banco_id

      t.timestamps
    end
    add_index :m_formatos, :m_formato
    add_index :m_formatos, :m_banco_id
  end
end
