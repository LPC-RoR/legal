class CreateMModelo < ActiveRecord::Migration[5.2]
  def change
    create_table :m_modelos do |t|
      t.string :m_modelo
      t.string :ownr_class
      t.integer :ownr_id
    end
    add_index :m_modelos, :ownr_class
    add_index :m_modelos, :ownr_id
  end
end
