# Marca como conciliadas (estado = 1) las DocTransacciones que ya tienen
# DocPago asociado; el resto queda como cargada (estado = 0, el default).
# Se hace en SQL puro para no depender del estado futuro de los modelos
# (AASM/enum) y funciona igual en MySQL (development) y PostgreSQL (production).
class MarcarTransaccionesConciliadas < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE doc_transacciones
      SET estado = 1
      WHERE EXISTS (
        SELECT 1
        FROM doc_pagos
        WHERE doc_pagos.doc_transaccion_id = doc_transacciones.id
      )
    SQL

    conciliadas = select_value("SELECT COUNT(*) FROM doc_transacciones WHERE estado = 1")
    say "Transacciones marcadas como conciliadas: #{conciliadas}"
  end

  def down
    execute "UPDATE doc_transacciones SET estado = 0"
  end
end
