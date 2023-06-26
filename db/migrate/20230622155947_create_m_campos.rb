class CreateMCampos < ActiveRecord::Migration[5.2]
  def change
    create_table :m_campos do |t|
      t.string :m_campo
      t.string :valor
      t.integer :m_conciliacion_id

      t.timestamps
    end
    add_index :m_campos, :m_campo
    add_index :m_campos, :m_conciliacion_id
  end
end
