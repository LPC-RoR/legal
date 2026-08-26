# app/services/annm/anonimizador_contenido.rb
module Annm
  class AnonimizadorContenido
    def initialize(contenido, codigos)
      @contenido = contenido.to_s
      @codigos = codigos.is_a?(Hash) ? codigos : {}
    end

    def anonimizar
      return @contenido if @codigos.empty?

      html? ? anonimizar_html : anonimizar_texto
    end

    private

    def html?
      @contenido.match?(/<[^>]+>/)
    end

    # --------------------------------------------------------------
    # Preserva la estructura HTML; solo muta nodos de texto
    # --------------------------------------------------------------
    def anonimizar_html
      require 'nokogiri'

      doc = Nokogiri::HTML.fragment(@contenido)

      doc.traverse do |node|
        next unless node.text? && node.content.present?

        texto_anon = reemplazar_en_texto(node.content)
        node.content = texto_anon if texto_anon != node.content
      end

      doc.to_html
    rescue => e
      Rails.logger.error "[Annm::AnonimizadorContenido] Error procesando HTML: #{e.message}"
      anonimizar_texto # Fallback seguro
    end

    def anonimizar_texto
      reemplazar_en_texto(@contenido)
    end

    # --------------------------------------------------------------
    # Reemplazo exacto ordenado por longitud descendente
    # para evitar reemplazos parciales (ej: "Ana" dentro de "Anabel")
    # --------------------------------------------------------------
    def reemplazar_en_texto(texto)
      return texto if texto.blank? || @codigos.empty?

      resultado = texto.dup

      @codigos.sort_by { |valor, _| -valor.to_s.length }.each do |valor, metadata|
        codigo = extraer_codigo(metadata)
        next if codigo.blank? || valor.to_s.strip.blank?

        pattern = Regexp.escape(valor.to_s)
        resultado.gsub!(/\b#{pattern}\b/i, codigo)
      end

      resultado
    end

    def extraer_codigo(metadata)
      case metadata
      when Hash   then metadata["codigo"] || metadata[:codigo]
      when String then metadata
      else nil
      end
    end
  end
end