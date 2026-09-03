# app/services/annm/diccionario_participantes.rb
module Annm
  class DiccionarioParticipantes
    def initialize(denuncia)
      @denuncia = denuncia
    end

    # Retorna Hash { "texto_a_buscar" => "placeholder" }
    def mapa_reemplazos
      mapa = {}
      participantes.each { |p| agregar_participante(mapa, p) }
      mapa
    end

    private

    def participantes
      @denuncia.krn_denunciantes.to_a +
        @denuncia.krn_denunciados.to_a +
        @denuncia.krn_testigos.to_a
    end

    def agregar_participante(mapa, prtcpnt)
      abrev = prtcpnt.kywrd[:abrev] rescue "P#{prtcpnt.id}"

      # --- RUT / CI ---
      if prtcpnt.rut.present?
        variantes_rut(prtcpnt.rut).each do |v|
          mapa[v] = "[CI-#{abrev}]"
        end
      end

      # --- NOMBRE (completo, parcial, etc.) ---
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

    def variantes_rut(rut)
      original = rut.to_s.strip
      sin_puntos = original.gsub('.', '')
      solo_numeros = original.gsub(/[.\-]/, '')

      [original, sin_puntos, solo_numeros].uniq.reject(&:blank?)
    end

    def variantes_nombre(nombre)
      base = nombre.to_s.strip
      partes = base.split(/\s+/)
      variantes = [base]

      if partes.length >= 2
        variantes << partes.first(2).join(' ')   # Nombre + 1er apellido
        variantes << partes.last(2).join(' ')    # Apellidos
      end

      variantes << partes.first if partes.length > 1   # Solo nombre
      variantes.uniq.reject(&:blank?)
    end
  end
end