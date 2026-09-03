# app/services/annm/reemplazador_html.rb
module Annm
  class ReemplazadorHtml
    def initialize(mapa_reemplazos)
      # Orden estricto: más largo primero para evitar reemplazos parciales
      @mapa = mapa_reemplazos.sort_by { |k, _| -k.to_s.length }
    end

    def reemplazar(html)
      html = html.to_s
      return html if html.blank? || @mapa.empty?

      Rails.logger.info "[Annm::Reemplazador] Iniciando. Entradas: #{@mapa.size}"

      # Estrategia: dividir HTML en etiquetas y texto plano.
      # Reemplazar solo en las partes de texto.
      partes = html.split(/(<[^>]+>)/)

      resultado = partes.map.with_index do |parte, idx|
        if parte.start_with?('<') && parte.end_with?('>')
          # Es una etiqueta HTML: no tocar
          parte
        else
          # Es texto plano: decodificar entities, reemplazar, recodificar
          texto_decodificado = decodificar_html_entities(parte)
          texto_reemplazado  = aplicar_reemplazos(texto_decodificado)
          codificar_html_entities(texto_reemplazado)
        end
      end.join

      # Logging de diagnóstico: contar cuántos placeholders de participantes quedaron
      conteo_participantes = resultado.scan(/\[[a-z]+-\d+\]/i).size
      conteo_genericos = resultado.scan(/\[(NOMBRE|CARGO|EMAIL|PROFESION|CI\|RUT)\]/).size
      Rails.logger.info "[Annm::Reemplazador] Completado. Placeholders participantes: #{conteo_participantes}, Genéricos: #{conteo_genericos}"

      resultado
    rescue => e
      Rails.logger.error "[Annm::ReemplazadorHtml] #{e.class}: #{e.message}"
      html
    end

    private

    # Decodifica &aacute; → á, &ntilde; → ñ, etc.
    def decodificar_html_entities(texto)
      CGI.unescapeHTML(texto)
    rescue
      texto
    end

    # Recodifica para no romper el HTML
    def codificar_html_entities(texto)
      # Solo recodificar <, >, & que no sean parte de etiquetas ya existentes
      # En realidad, como solo tocamos texto entre etiquetas, no debería haber < o >
      # Pero por seguridad, escapamos solo & que no sean de entities existentes
      texto.gsub('&', '&amp;')
           .gsub('<', '&lt;')
           .gsub('>', '&gt;')
    end

    def aplicar_reemplazos(texto)
      return texto if texto.blank?

      resultado = texto.dup

      @mapa.each do |valor, reemplazo|
        next if valor.to_s.strip.blank? || valor.to_s.length < 2

        pattern = Regexp.escape(valor.to_s)

        # Regex robusta: word boundary Unicode sin depender de \b (que falla con tildes)
        # (?<!\p{L}) = no precedido por letra Unicode
        # (?!\p{L})  = no seguido por letra Unicode
        regex = /(?<!\p{L})#{pattern}(?!\p{L})/iu

        next unless resultado.match?(regex)

        count_before = resultado.scan(regex).size
        resultado.gsub!(regex, reemplazo)
        Rails.logger.info "[Annm::Reemplazador] Reemplazado '#{valor}' → '#{reemplazo}' (#{count_before} ocurrencias)"
      end

      resultado
    end
  end
end