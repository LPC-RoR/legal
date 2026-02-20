# app/validators/valida_rut_validator.rb

class ValidaRutValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    fctrs = [2, 3, 4, 5, 6, 7, 2, 3]

    v_format = !!(value.to_s.strip =~ /^[\d]{1,2}\.?[\d]{3}\.?[\d]{3}\-?[\dkK]{1}$/)

    if v_format
      stripped = value.to_s.strip.downcase
      
      # valor verificador del dígito
      vrfy_dgt = stripped[-1] == 'k' ? 10 : stripped[-1].to_i

      # Extraer la parte numérica (antes del dígito verificador)
      numeric_part = if stripped =~ /-/
                       stripped.split('-')[0].gsub(/[^0-9]/, '')
                     else
                       stripped[0..-2].gsub(/[^0-9]/, '')
                     end
      
      # Validar que no tenga más de 8 dígitos
      if numeric_part.length > 8
        record.errors.add(attribute, :invalid_rut, message: "rut no válido")
        return
      end

      # Calcular dígito verificador
      arr = numeric_part.reverse.chars.map(&:to_i)
      rst = arr.each_with_index.map { |c, i| c * fctrs[i] }.sum % 11
      vrfy_rut = rst == 0 ? 0 : 11 - rst
      vrfy = vrfy_dgt == vrfy_rut
    else
      vrfy = false
    end

    unless vrfy
      record.errors.add(attribute, :invalid_rut, message: "rut no válido")
    end
  end

end