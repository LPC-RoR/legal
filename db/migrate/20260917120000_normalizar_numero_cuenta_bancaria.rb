# La extracción del número de cuenta era inconsistente entre formatos:
#   - Cartola histórica (mensual): "Cuenta Corriente N°: 0-000-7309054-7" -> "0-000-7309054-7"
#   - Cartola provisoria:          "Cuenta 0-000-7309054-7"               -> "Cuenta 0-000-7309054-7"
# Esto creaba DOS DocCuenta para la misma cuenta bancaria y la deduplicación
# de transacciones dejaba de funcionar al cargar la cartola mensual.
#
# Esta migración normaliza numero_cuenta y fusiona las cuentas duplicadas.
class NormalizarNumeroCuentaBancaria < ActiveRecord::Migration[8.0]
  def normalizar(valor)
    return valor if valor.blank?

    texto = valor.to_s.strip
    if (match = texto.match(/N°?\s*:\s*(.+)/))
      match[1].strip
    elsif (match = texto.match(/\bCuenta\b\s*(.+)/i))
      match[1].strip
    elsif (match = texto.match(/\d+(?:-\d+)+/))
      match[0]
    else
      texto
    end
  end

  def up
    DocCuenta.reset_column_information

    DocCuenta.find_each do |cuenta|
      normalizado = normalizar(cuenta.numero_cuenta)
      next if normalizado == cuenta.numero_cuenta

      existente = DocCuenta.where.not(id: cuenta.id).find_by(numero_cuenta: normalizado)

      if existente
        say "Fusionando DocCuenta ##{cuenta.id} (#{cuenta.numero_cuenta}) en DocCuenta ##{existente.id} (#{normalizado})"
        cuenta.doc_cartolas.update_all(doc_cuenta_id: existente.id)
        cuenta.doc_transacciones.update_all(doc_cuenta_id: existente.id)
        cuenta.delete
      else
        say "Normalizando DocCuenta ##{cuenta.id}: #{cuenta.numero_cuenta} -> #{normalizado}"
        cuenta.update_column(:numero_cuenta, normalizado)
      end
    end
  end

  def down
    # No reversible: no se puede reconstruir el texto original mal formado
    raise ActiveRecord::IrreversibleMigration
  end
end
