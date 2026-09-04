# app/services/annm/anonimizador_declaraciones.rb
module Annm
  class AnonimizadorDeclaraciones
    def initialize(denuncia)
      @denuncia = denuncia
      dic = Annm::DiccionarioParticipantes.new(denuncia)
      @diccionario = dic.mapa_reemplazos
      @resumen_llm = dic.resumen_para_llm
      @reemplazador = Annm::ReemplazadorHtml.new(@diccionario)
      @generico = Annm::AnonimizadorGenerico.new(@resumen_llm)
    end

    def anonimizar(html)
      html = html.to_s
      return "" if html.blank?

      # PASO 1: Reemplazo exacto
      paso_1 = @reemplazador.reemplazar(html)
      paso_1 = colapsar_placeholders(paso_1)

      # PASO 2: LLM con contexto
      paso_2 = @generico.anonimizar(paso_1)
      paso_2 = colapsar_placeholders(paso_2)

      # Limpieza final
      paso_2 = limpiar_hibridos(paso_2)
      paso_2 = colapsar_genericos(paso_2)

      paso_2
    end

    private

    # ================================================================
    # Colapsa placeholders idénticos consecutivos, INCLUSO si entre
    # medio hay espacios, saltos de línea o etiquetas HTML.
    # Ej: [dnncd-47]</strong> <em>[dnncd-47] → [dnncd-47]
    # ================================================================
    def colapsar_placeholders(texto)
      20.times do # límite de seguridad
        # [CODE] + (espacios y/o etiquetas HTML)+ + [MISMO CODE]
        nuevo = texto.gsub(/(\[[^\]]+\])(?:(?:\s|<[^>]+>)+)\1/, '\1')
        break if nuevo == texto
        texto = nuevo
      end
      texto
    end

    # Limpia híbridos como [dnncd-47] [NOMBRE] o [NOMBRE] [dnncd-47]
    def limpiar_hibridos(texto)
      texto.gsub(/\[NOMBRE\]\s*(\[[^\]]+\])/i, '\1')
           .gsub(/(\[[^\]]+\])\s*\[NOMBRE\]/i, '\1')
    end

    # Colapsa genéricos duplicados: [NOMBRE] [NOMBRE] → [NOMBRE]
    def colapsar_genericos(texto)
      %w[NOMBRE CARGO EMAIL PROFESION CI\|RUT].each do |tag|
        regex = /\[#{Regexp.escape(tag)}\](?:\s*\[#{Regexp.escape(tag)}\])+/
        texto.gsub!(regex, "[#{tag}]")
      end
      texto
    end
  end
end