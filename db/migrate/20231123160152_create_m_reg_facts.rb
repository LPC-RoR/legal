class CreateMRegFacts < ActiveRecord::Migration[5.2]
  def change
    create_table :m_reg_facts do |t|
      t.integer :m_registro_id
      t.integer :tar_factura_id
      t.decimal :monto

      t.timestamps
    end
    add_index :m_reg_facts, :m_registro_id
    add_index :m_reg_facts, :tar_factura_id
  end
end
