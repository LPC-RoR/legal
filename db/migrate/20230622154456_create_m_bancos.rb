class CreateMBancos < ActiveRecord::Migration[5.2]
  def change
    create_table :m_bancos do |t|
      t.string :m_banco
      t.integer :m_modelo_id

      t.timestamps
    end
    add_index :m_bancos, :m_banco
    add_index :m_bancos, :m_modelo_id
  end
end
