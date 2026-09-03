# app/services/annm/reemplazador_html.rb
module Annm
  class ReemplazadorHtml
    def initialize(mapa_reemplazos)
      # Orden descendente por longitud para evitar reemplazos parciales
      @mapa = mapa_reemplazos.sort_by { |k, _| -k.to_s.length }
    end

    def reemplazar(html)
      return html if html.blank? || @mapa.empty?

      doc = Nokogiri::HTML.fragment(html.to_s)

      doc.traverse do |node|
        next unless node.text? && node.content.present?

        texto_original = node.content
        texto_nuevo    = aplicar_reemplazos(texto_original)

        node.content = texto_nuevo if texto_nuevo != texto_original
      end

      doc.to_html
    rescue => e
      Rails.logger.error "[Annm::ReemplazadorHtml] #{e.message}"
      aplicar_reemplazos(html.to_s) # Fallback directo
    end

    private

    def aplicar_reemplazos(texto)
      resultado = texto.dup

      @mapa.each do |valor, reemplazo|
        next if valor.to_s.strip.blank?
        pattern = Regexp.escape(valor.to_s)
        # Lookarounds para evitar reemplazar dentro de otras palabras
        resultado.gsub!(/(?<!\w)#{pattern}(?!\w)/i, reemplazo)
      end

      resultado
    end
  end
end