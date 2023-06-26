class CreateMCuentas < ActiveRecord::Migration[5.2]
  def change
    create_table :m_cuentas do |t|
      t.string :m_cuenta
      t.integer :m_banco_id

      t.timestamps
    end
    add_index :m_cuentas, :m_banco_id
  end
end
