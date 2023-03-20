# app/validators/existe_empresa_validator.rb

class ValidaRutValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # value : RUT
    # arreglo que nos permite saber si un caracter es dígito
  	digit = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    char_rut = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'k', 'K']
    factores = [2, 3, 4, 5, 6, 7, 2, 3]
    # se usa para saber por que factor multiplicar
  	factor = 0
    # estado inicial
  	estado = 0
    # suma de los dígitos ponderados
  	suma = 0
    # i se usa para guardar la posición en la que se recorre el RUT
    i = 0
    # se invierte (reverse) el rut para recorrerlo 
    # como i parte en cero se recorre en lenght-1
    while i < value.length
      char = value.reverse[i]
    	if estado == 0 # inicio
    	  # dígito verificador
        if char_rut.include? char 
        	verificador = char.downcase == 'k' ? 10 : char.to_i
          estado = 1
        else
        	estado = 100
        end
      elsif estado == 1 # digito verificador capturado
        if digit.include? char
          suma += char.to_i * factores[factor]
          factor += 1
          estado = 2
        elsif char == '-'
        else
          estado == 100
        end
      elsif estado == 2 
        if digit.include? char
          suma += char.to_i * factores[factor]
          factor += 1
        elsif char == '.'
        else
        	estado = 100
        end
    	end
      i += 1
    end

    resultado = 11 - (suma % 11) == 11 ? 0 : 11 - (suma % 11)

    estado = 100 if verificador != resultado

  	if estado == 100
  	  record.errors[attribute] << (options[:message] || ": rut no valido")
  	end
  end
end