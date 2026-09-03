# app/services/annm/diccionario_participantes.rb
module Annm
  class DiccionarioParticipantes
    def initialize(denuncia)
      @denuncia = denuncia
    end

    # Retorna Hash { "texto_a_buscar" => "placeholder" }
    # Ordenado por longitud descendente para evitar reemplazos parciales
    def mapa_reemplazos
      mapa = {}
      participantes.each { |p| agregar_participante(mapa, p) }
      mapa.sort_by { |k, _| -k.to_s.length }.to_h
    end

    private

    def participantes
      @denuncia.krn_denunciantes.to_a +
        @denuncia.krn_denunciados.to_a +
        @denuncia.krn_testigos.to_a
    end

    def agregar_participante(mapa, prtcpnt)
      abrev = prtcpnt.kywrd[:abrev] rescue "P#{prtcpnt.id}"

      # --- RUT / CI (todas las variantes de formato) ---
      if prtcpnt.rut.present?
        variantes_rut(prtcpnt.rut).each do |v|
          mapa[v] = "[CI-#{abrev}]"
        end
      end

      # --- NOMBRE (completo, parcial e individuales) ---
      if prtcpnt.nombre.present?
        variantes_nombre(prtcpnt.nombre).each do |v|
          mapa[v] = "[#{abrev}]"
        end
      end

      # --- EMAIL ---
      mapa[prtcpnt.email] = "[EMAIL-#{abrev}]" if prtcpnt.email.present?

      # --- CARGO ---
      cargo = prtcpnt.try(:cargo)
      mapa[cargo] = "[CARGO-#{abrev}]" if cargo.present?
    end

    # --------------------------------------------------------------
    # RUT: genera todas las variantes de formato comunes
    # --------------------------------------------------------------
    def variantes_rut(rut)
      original = rut.to_s.strip
      sin_puntos = original.gsub('.', '')
      solo_numeros = original.gsub(/[.\-]/, '')
      con_guion = solo_numeros.dup
      con_guion = con_guion[0...-1] + '-' + con_guion[-1] if con_guion.length > 1

      [original, sin_puntos, solo_numeros, con_guion].uniq.reject(&:blank?)
    end

    # --------------------------------------------------------------
    # NOMBRE: genera TODAS las combinaciones relevantes
    #
    # Heurística para español de Chile:
    #   - 1 palabra:  nombre único
    #   - 2 palabras: nombre + apellido
    #   - 3 palabras: nombre + 2 apellidos  O  2 nombres + 1 apellido
    #   - 4+ palabras: 2 nombres + 2 apellidos (asume últimas 2 = apellidos)
    # --------------------------------------------------------------
    def variantes_nombre(nombre)
      base = nombre.to_s.strip
      partes = base.split(/\s+/).reject(&:blank?)
      return [base] if partes.empty?

      variantes = [base]  # Nombre completo

      case partes.size
      when 2
        # A B → A, B
        variantes.concat(partes)
      when 3
        # A B C → A C, A B, B C, A, B, C
        # Cubre tanto 2 nombres+1 apellido como 1 nombre+2 apellidos
        variantes << "#{partes[0]} #{partes[2]}"  # primero + último
        variantes << "#{partes[0]} #{partes[1]}"  # primero + medio
        variantes << "#{partes[1]} #{partes[2]}"  # medio + último
        variantes.concat(partes)                   # A, B, C
      else
        # 4+ palabras: asume últimas 2 = apellidos
        nombres   = partes[0..-3]
        apellidos = partes[-2..-1]

        # Primer nombre + todos los apellidos
        variantes << "#{partes[0]} #{apellidos.join(' ')}"
        # Primer nombre + primer apellido
        variantes << "#{partes[0]} #{apellidos[0]}"
        # Todos los nombres juntos
        variantes << nombres.join(' ') if nombres.size > 1
        # Todos los apellidos juntos
        variantes << apellidos.join(' ')
        # Cada palabra individual (CRÍTICO: antes faltaba esto)
        variantes.concat(partes)
      end

      variantes.uniq.reject(&:blank?)
    end
  end
end