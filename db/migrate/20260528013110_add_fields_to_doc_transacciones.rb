class AddFieldsToDocTransacciones < ActiveRecord::Migration[8.0]
  def change
    # Agregar referencia a doc_cartola si no existe
    unless column_exists?(:doc_transacciones, :doc_cartola_id)
      add_reference :doc_transacciones, :doc_cartola, null: false, foreign_key: true
    end

    # Agregar referencia a doc_cuenta si no existe
    unless column_exists?(:doc_transacciones, :doc_cuenta_id)
      add_reference :doc_transacciones, :doc_cuenta, null: false, foreign_key: true
    end

    # Agregar descripcion_rut si no existe
    unless column_exists?(:doc_transacciones, :descripcion_rut)
      add_column :doc_transacciones, :descripcion_rut, :string
    end

    # Agregar fecha si no existe
    unless column_exists?(:doc_transacciones, :fecha)
      add_column :doc_transacciones, :fecha, :date
    end

    # Agregar numero_documento si no existe
    unless column_exists?(:doc_transacciones, :numero_documento)
      add_column :doc_transacciones, :numero_documento, :string
    end

    # Agregar sucursal si no existe
    unless column_exists?(:doc_transacciones, :sucursal)
      add_column :doc_transacciones, :sucursal, :string
    end

    # Agregar tipo_movimiento si no existe
    unless column_exists?(:doc_transacciones, :tipo_movimiento)
      add_column :doc_transacciones, :tipo_movimiento, :string
    end

    # Agregar campos polimórficos si no existen
    unless column_exists?(:doc_transacciones, :relacionable_type)
      add_column :doc_transacciones, :relacionable_type, :string
    end

    unless column_exists?(:doc_transacciones, :relacionable_id)
      add_column :doc_transacciones, :relacionable_id, :bigint
    end

    # Índices
    unless index_exists?(:doc_transacciones, [:doc_cartola_id, :fecha])
      add_index :doc_transacciones, [:doc_cartola_id, :fecha]
    end

    unless index_exists?(:doc_transacciones, :descripcion_rut)
      add_index :doc_transacciones, :descripcion_rut
    end

    unless index_exists?(:doc_transacciones, [:relacionable_type, :relacionable_id])
      add_index :doc_transacciones, [:relacionable_type, :relacionable_id]
    end
  end
end
