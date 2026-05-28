class AddFieldsToDocCuentas < ActiveRecord::Migration[8.0]
  def change
    # Agregar referencia a doc_banco si no existe
    unless column_exists?(:doc_cuentas, :doc_banco_id)
      add_reference :doc_cuentas, :doc_banco, null: false, foreign_key: true
    end

    # Agregar moneda si no existe
    unless column_exists?(:doc_cuentas, :moneda)
      add_column :doc_cuentas, :moneda, :string
    end

    # Agregar sucursal si no existe
    unless column_exists?(:doc_cuentas, :sucursal)
      add_column :doc_cuentas, :sucursal, :string
    end

    # Agregar tipo_cuenta si no existe
    unless column_exists?(:doc_cuentas, :tipo_cuenta)
      add_column :doc_cuentas, :tipo_cuenta, :string, default: 'corriente'
    end

    # Índice único en numero_cuenta si no existe
    unless index_exists?(:doc_cuentas, :numero_cuenta)
      add_index :doc_cuentas, :numero_cuenta, unique: true
    end
  end
end
