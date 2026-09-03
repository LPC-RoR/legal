# app/services/annm/diccionario_participantes.rb
module Annm
  class DiccionarioParticipantes
    TITULOS = %w[Sr. Sra. Dr. Dra. Ing. Lic. Prof. Don Doña].freeze

    def initialize(denuncia)
      @denuncia = denuncia
    end

    def mapa_reemplazos
      mapa = {}
      participantes.each { |p| agregar_participante(mapa, p) }

      ordenado = mapa.sort_by { |k, _| -k.to_s.length }.to_h

      Rails.logger.info "[Annm::Diccionario] Total entradas: #{ordenado.size}"
      Rails.logger.info "[Annm::Diccionario] Primeras 20: #{ordenado.keys.first(20).join(' | ')}"

      ordenado
    end

    private

    def participantes
      @denuncia.krn_denunciantes.to_a +
        @denuncia.krn_denunciados.to_a +
        @denuncia.krn_testigos.to_a
    end

    def agregar_participante(mapa, prtcpnt)
      abrev = prtcpnt.respond_to?(:kywrd) ? prtcpnt.kywrd[:abrev] : "P#{prtcpnt.id}"
      Rails.logger.info "[Annm::Diccionario] Participante #{prtcpnt.class.name}##{prtcpnt.id} → abrev: #{abrev}, nombre: #{prtcpnt.nombre.inspect}, rut: #{prtcpnt.rut.inspect}, email: #{prtcpnt.email.inspect}, cargo: #{prtcpnt.try(:cargo).inspect}"

      # --- RUT / CI ---
      if prtcpnt.rut.present?
        variantes_rut(prtcpnt.rut).each { |v| mapa[v] = "[CI-#{abrev}]" }
      end

      # --- NOMBRE ---
      if prtcpnt.nombre.present?
        variantes_nombre(prtcpnt.nombre).each { |v| mapa[v] = "[#{abrev}]" }
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
      con_guion = solo_numeros.dup
      con_guion = con_guion[0...-1] + '-' + con_guion[-1] if con_guion.length > 1

      [original, sin_puntos, solo_numeros, con_guion].uniq.reject(&:blank?)
    end

    def variantes_nombre(nombre_completo)
      base = nombre_completo.to_s.strip
      partes = base.split(/\s+/).reject(&:blank?)
      return [base] if partes.empty?

      variantes = Set.new

      # 1. Nombre completo original
      variantes << base

      # 2. Todas las combinaciones de 2+ palabras consecutivas
      (2..partes.size).each do |len|
        partes.each_cons(len) do |slice|
          variantes << slice.join(' ')
        end
      end

      # 3. Cada palabra individual (CRÍTICO para "Armijo", "Pérez", etc.)
      variantes.merge(partes)

      # 4. Con títulos
      con_titulos = Set.new
      variantes.each do |v|
        next if v.blank?
        TITULOS.each { |t| con_titulos << "#{t} #{v}" }
      end
      variantes.merge(con_titulos)

      # 5. Sin tildes (normalización NFD)
      sin_tildes = Set.new
      variantes.each do |v|
        next if v.blank?
        st = v.unicode_normalize(:nfd).gsub(/\p{Mn}/, '')
        sin_tildes << st if st != v
      end
      variantes.merge(sin_tildes)

      # 6. En minúsculas (fallback por si acaso)
      minusculas = Set.new
      variantes.each do |v|
        next if v.blank?
        minusculas << v.downcase if v.downcase != v
      end
      variantes.merge(minusculas)

      resultado = variantes.to_a.uniq.reject(&:blank?)
      Rails.logger.info "[Annm::Diccionario] Nombre '#{base}' → #{resultado.size} variantes: #{resultado.join(', ')}"
      resultado
    end
  end
end