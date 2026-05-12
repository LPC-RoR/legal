module RutNormalizable
  extend ActiveSupport::Concern

  included do
    before_validation :normalizar_rut
    validate :rut_chileno_valido
  end

  private

  def normalizar_rut
    return if rut.blank?
    self.rut = rut.gsub(/[.\-]/, '').upcase
  end

  def rut_chileno_valido
    return if rut.blank?

    unless rut.match?(/\A\d{7,8}[\dK]\z/)
      errors.add(:rut, "formato inválido. Use: 12345678-9, 12.345.678-9 o 12345678K")
      return
    end

    cuerpo = rut[0..-2].to_i
    dv_ingresado = rut[-1]
    dv_calculado = calcular_dv(cuerpo)

    unless dv_ingresado == dv_calculado
      errors.add(:rut, "dígito verificador incorrecto")
    end
  end

  def calcular_dv(numero)
    suma = 0
    multiplicador = 2

    numero.digits.each do |digito|
      suma += digito * multiplicador
      multiplicador = multiplicador == 7 ? 2 : multiplicador + 1
    end

    resto = suma % 11
    resultado = 11 - resto

    case resultado
    when 11 then '0'
    when 10 then 'K'
    else resultado.to_s
    end
  end

end