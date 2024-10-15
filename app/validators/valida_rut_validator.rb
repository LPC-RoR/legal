# app/validators/existe_empresa_validator.rb

class ValidaRutValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)

    fctrs = [2, 3, 4, 5, 6, 7, 2, 3]

    v_format = !!( value.strip =~ /^[\d]{1,2}\.?[\d]{3}\.?[\d]{3}\-?[\dkK]{1}/ )

    if v_format
      # valor verificador del dígito
      vrfy_dgt = value.strip[-1].downcase == 'k' ? 10 : value.strip[-1].to_i

      # valor verificador del número
      arr = value.split('-')[0].gsub('.', '').reverse.split('')
      rst = arr.each_with_index.map {|c, i| c.to_i * fctrs[i]}.sum % 11
      vrfy_rut = rst == 0 ? 0 : 11 - rst

      vrfy = vrfy_dgt == vrfy_rut
    else
      vrfy = false
    end

    unless vrfy
      record.errors[attribute] << (options[:message] || ": rut no valido")
    end
  end

end