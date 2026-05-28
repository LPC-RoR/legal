class CreateDocCuentas < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_cuentas do |t|
      t.references :doc_banco, null: false, foreign_key: true
      t.string :numero_cuenta, null: false
      t.string :moneda
      t.string :sucursal
      t.string :tipo_cuenta, default: 'corriente'

      t.timestamps
    end

    add_index :doc_cuentas, :numero_cuenta, unique: true
  end
end
