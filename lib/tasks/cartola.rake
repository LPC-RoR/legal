namespace :cartola do
  desc "Elimina DocTransacciones duplicadas (misma cuenta, fecha, monto y descripción). " \
       "Conserva el registro con asociaciones (pagos/notas/relacionable) o, en su defecto, el más antiguo."
  task depurar_duplicados: :environment do
    grupos = DocTransaccion.includes(:doc_pagos, :doc_notas).find_each.each_with_object({}) do |trans, hash|
      clave = [
        trans.doc_cuenta_id,
        trans.fecha&.to_s,
        trans.monto&.round(2).to_s,
        trans.descripcion.to_s.squish.downcase
      ]
      (hash[clave] ||= []) << trans
    end

    duplicados = grupos.select { |_, v| v.size > 1 }
    eliminadas = 0

    duplicados.each_value do |transacciones|
      # Prioridad: con asociaciones primero, luego la de menor id (la original)
      conservar = transacciones.sort_by do |t|
        [t.doc_pagos.any? || t.doc_notas.any? || t.relacionable.present? ? 0 : 1, t.id]
      end.first

      transacciones.reject { |t| t.id == conservar.id }.each do |duplicada|
        puts "Eliminando DocTransaccion ##{duplicada.id} (duplicada de ##{conservar.id}): " \
             "#{duplicada.fecha} | #{duplicada.monto} | #{duplicada.descripcion}"
        duplicada.destroy!
        eliminadas += 1
      end
    end

    puts "Listo: #{duplicados.size} grupos con duplicados, #{eliminadas} transacciones eliminadas."
  end
end
