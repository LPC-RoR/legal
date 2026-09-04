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
      mapa.sort_by { |k, _| -k.to_s.length }.to_h
    end

    def resumen_para_llm
      resumen = {}
      participantes.each do |p|
        abrev = p.respond_to?(:kywrd) ? p.kywrd[:abrev] : "P#{p.id}"
        resumen[abrev] = {
          nombre: p.nombre.to_s,
          cargo: p.try(:cargo).to_s,
          email: p.email.to_s,
          rut: p.rut.to_s
        }
      end
      resumen
    end

    private

    def participantes
      @denuncia.krn_denunciantes.to_a +
        @denuncia.krn_denunciados.to_a +
        @denuncia.krn_testigos.to_a
    end

    def agregar_participante(mapa, prtcpnt)
      abrev = prtcpnt.respond_to?(:kywrd) ? prtcpnt.kywrd[:abrev] : "P#{prtcpnt.id}"

      # --- RUT / CI ---
      if prtcpnt.rut.present?
        variantes_rut(prtcpnt.rut).each { |v| mapa[v] = "[CI-#{abrev}]" }
      end

      # --- NOMBRE ---
      if prtcpnt.nombre.present?
        variantes_nombre(prtcpnt.nombre).each { |v| mapa[v] = "[#{abrev}]" }
      end

      # --- EMAIL (incluye variantes con < >) ---
      if prtcpnt.email.present?
        email = prtcpnt.email.to_s.strip
        mapa[email] = "[EMAIL-#{abrev}]"
        mapa["<#{email}>"] = "[EMAIL-#{abrev}]"   # <canaldedenuncias@emprender.cl>
        mapa["#{email}>"] = "[EMAIL-#{abrev}]"    # canaldedenuncias@emprender.cl>
        mapa["<#{email}"] = "[EMAIL-#{abrev}]"    # <canaldedenuncias@emprender.cl
      end

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
      variantes << base

      (2..partes.size).each do |len|
        partes.each_cons(len) { |slice| variantes << slice.join(' ') }
      end
      variantes.merge(partes)

      con_titulos = Set.new
      variantes.each do |v|
        next if v.blank?
        TITULOS.each { |t| con_titulos << "#{t} #{v}" }
      end
      variantes.merge(con_titulos)

      sin_tildes = Set.new
      variantes.each do |v|
        next if v.blank?
        st = v.unicode_normalize(:nfd).gsub(/\p{Mn}/, '')
        sin_tildes << st if st != v
      end
      variantes.merge(sin_tildes)

      minusculas = Set.new
      variantes.each do |v|
        next if v.blank?
        minusculas << v.downcase if v.downcase != v
      end
      variantes.merge(minusculas)

      variantes.to_a.uniq.reject(&:blank?)
    end
  end
end