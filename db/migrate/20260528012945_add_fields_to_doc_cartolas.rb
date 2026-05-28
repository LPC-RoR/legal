class AddFieldsToDocCartolas < ActiveRecord::Migration[8.0]
  def change
    # Agregar referencia a doc_cuenta si no existe
    unless column_exists?(:doc_cartolas, :doc_cuenta_id)
      add_reference :doc_cartolas, :doc_cuenta, null: false, foreign_key: true
    end

    # Agregar numero_cartola si no existe
    unless column_exists?(:doc_cartolas, :numero_cartola)
      add_column :doc_cartolas, :numero_cartola, :integer
    end

    # Agregar fecha_desde si no existe
    unless column_exists?(:doc_cartolas, :fecha_desde)
      add_column :doc_cartolas, :fecha_desde, :date
    end

    # Agregar fecha_hasta si no existe
    unless column_exists?(:doc_cartolas, :fecha_hasta)
      add_column :doc_cartolas, :fecha_hasta, :date
    end

    # Agregar campos de saldos si no existen
    campos_saldos = {
      saldo_inicial: { precision: 15, scale: 2 },
      depositos: { precision: 15, scale: 2 },
      otros_abonos: { precision: 15, scale: 2 },
      cheques: { precision: 15, scale: 2 },
      otros_cargos: { precision: 15, scale: 2 },
      impuestos: { precision: 15, scale: 2 },
      saldo_final: { precision: 15, scale: 2 },
      cupo_aprobado: { precision: 15, scale: 2 },
      monto_utilizado: { precision: 15, scale: 2 },
      saldo_disponible: { precision: 15, scale: 2 }
    }

    campos_saldos.each do |campo, opciones|
      unless column_exists?(:doc_cartolas, campo)
        add_column :doc_cartolas, campo, :decimal, **opciones
      end
    end
  end
end
