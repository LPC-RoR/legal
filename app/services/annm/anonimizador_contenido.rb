# app/services/annm/anonimizador_contenido.rb
module Annm
  class AnonimizadorContenido
    EMAIL_REGEX = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/

    def initialize(denuncia)
      @denuncia = denuncia
      dic = Annm::DiccionarioParticipantes.new(denuncia)
      @diccionario = dic.mapa_reemplazos
      @resumen_llm = dic.resumen_para_llm
      @reemplazador = Annm::ReemplazadorHtml.new(@diccionario)
      @generico = Annm::AnonimizadorGenerico.new(
        resumen_participantes: @resumen_llm
      )
    end

    def anonimizar(texto)
      texto = texto.to_s
      return "" if texto.blank?

      # PASO 0: Normalización de espacios
      # - U+00A0 (NBSP real, producto de decodificar &nbsp; del rich text)
      # - '&nbsp;' / '&nbsp' literal (el LLM a veces lo emite como texto)
      # Va ANTES del reemplazo exacto: 'Juan&nbsp;Pérez' no matchearía el
      # hash, pero 'Juan Pérez' sí.
      texto = normalizar_espacios(texto)

      # PASO 1: Reemplazo exacto de participantes
      paso_1 = @reemplazador.reemplazar(texto)
      paso_1 = colapsar_placeholders(paso_1)

      # PASO 2: Regex para emails genéricos (incluye <email>, &lt;email&gt;)
      paso_2 = anonimizar_emails_genericos(paso_1)

      # PASO 3: LLM con contexto de participantes
      paso_3 = @generico.anonimizar(paso_2)
      paso_3 = colapsar_placeholders(paso_3)

      # Limpieza final
      paso_3 = limpiar_hibridos(paso_3)
      paso_3 = colapsar_genericos(paso_3)
      paso_3 = normalizar_espacios(paso_3)
      paso_3 = colapsar_espacios_dobles(paso_3)

      paso_3
    end

    private

    # ================================================================
    # Normalización de espacios: NBSP real y entidad &nbsp residual
    # ================================================================
    def normalizar_espacios(texto)
      texto.gsub(/\u00A0/, ' ')      # NBSP decodificado del rich text
           .gsub(/&nbsp;?/i, ' ')    # entidad literal (Trix sin decodificar o LLM)
    end

    # Los &nbsp; del original existen para preservar espacios múltiples;
    # una vez normalizados, se colapsan a un espacio simple
    def colapsar_espacios_dobles(texto)
      texto.gsub(/ {2,}/, ' ')
    end

    # ================================================================
    # Captura emails genéricos: sueltos, entre < > o entre &lt; &gt;
    # ================================================================
    def anonimizar_emails_genericos(texto)
      return texto if texto.blank?

      resultado = texto.dup

      # 1. Emails entre HTML entities: &lt;canaldedenuncias@emprender.cl&gt;
      resultado.gsub!(/&lt;\s*(#{EMAIL_REGEX})\s*&gt;/, '[EMAIL]')

      # 2. Emails entre corchetes angulares: <canaldedenuncias@emprender.cl>
      resultado.gsub!(/<\s*(#{EMAIL_REGEX})\s*>/, '[EMAIL]')

      # 3. Emails sueltos que aún no han sido reemplazados
      # (los de participantes ya fueron reemplazados en paso 1 a [EMAIL-XX-NN])
      resultado.gsub!(EMAIL_REGEX, '[EMAIL]')

      resultado
    end

    def colapsar_placeholders(texto)
      20.times do
        nuevo = texto.gsub(/(\[[^\]]+\])(?:(?:\s|<[^>]+>)+)\1/, '\1')
        break if nuevo == texto
        texto = nuevo
      end
      texto
    end

    def limpiar_hibridos(texto)
      texto.gsub(/\[NOMBRE\]\s*(\[[^\]]+\])/i, '\1')
           .gsub(/(\[[^\]]+\])\s*\[NOMBRE\]/i, '\1')
    end

    def colapsar_genericos(texto)
      %w[NOMBRE CARGO EMAIL PROFESION CI\|RUT].each do |tag|
        regex = /\[#{Regexp.escape(tag)}\](?:\s*\[#{Regexp.escape(tag)}\])+/
        texto.gsub!(regex, "[#{tag}]")
      end
      texto
    end
  end
end