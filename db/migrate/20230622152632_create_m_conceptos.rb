class CreateMConceptos < ActiveRecord::Migration[5.2]
  def change
    create_table :m_conceptos do |t|
      t.string :m_concepto
      t.integer :m_modelo_id

      t.timestamps
    end
    add_index :m_conceptos, :m_concepto
    add_index :m_conceptos, :m_modelo_id
  end
end
