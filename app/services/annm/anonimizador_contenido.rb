# app/services/annm/anonimizador_contenido.rb
module Annm
  class AnonimizadorContenido
    EMAIL_REGEX = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/

    # Tamaño máximo por chunk enviado al LLM (caracteres).
    # ~8.000 chars ≈ 2.500 tokens: holgado frente al max_tokens de salida.
    LIMITE_CHUNK = 8_000

    # Tags de bloque por los que se parte (contenido ActionText/Trix)
    BLOQUES = /(?=<(?:p|div|h[1-6]|ul|ol|li|blockquote|table|tr)\b)/

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

    # ------------------------------------------------------------
    # Punto de entrada: texto completo → texto anonimizado.
    # Parte en chunks para no truncar textos largos.
    # ------------------------------------------------------------
    def anonimizar(texto)
      texto = normalizar_espacios(texto.to_s)
      return "" if texto.blank?

      chunks = partir_en_chunks(texto)

      resultado = chunks.map { |chunk| anonimizar_chunk(chunk) }.join

      # Limpieza final sobre el texto REUNIDO: colapsa placeholders
      # quedados a medias en los bordes entre chunks
      resultado = limpiar_hibridos(resultado)
      resultado = colapsar_genericos(resultado)
      resultado = colapsar_placeholders(resultado)
      resultado = normalizar_espacios(resultado)
      resultado = colapsar_espacios_dobles(resultado)

      resultado
    end

    private

    # ================================================================
    # PIPELINE POR CHUNK
    # ================================================================
    def anonimizar_chunk(texto)
      # PASO 1: Reemplazo exacto de participantes
      paso_1 = @reemplazador.reemplazar(texto)
      paso_1 = colapsar_placeholders(paso_1)

      # PASO 2: Regex para emails genéricos (incluye <email>, &lt;email&gt;)
      paso_2 = anonimizar_emails_genericos(paso_1)

      # PASO 3: LLM con contexto de participantes
      paso_3 = @generico.anonimizar(paso_2)
      colapsar_placeholders(paso_3)
    end

    # ================================================================
    # CHUNKING
    # ================================================================
    def partir_en_chunks(texto, limite: LIMITE_CHUNK)
      return [texto] if texto.length <= limite

      segmentos = texto.split(BLOQUES).reject(&:blank?)
      # Fallback para texto plano sin tags: partir por párrafos
      segmentos = texto.split(/\n{2,}/) if segmentos.size <= 1

      chunks = []
      actual = +""

      segmentos.each do |seg|
        if actual.empty?
          actual = seg.dup
        elsif (actual.length + seg.length) <= limite
          actual << seg
        else
          chunks << actual
          actual = seg.dup
        end
      end
      chunks << actual if actual.present?

      # Segmento individual que supere el límite: corte duro aproximado
      # por palabra (caso patológico: párrafo gigante sin estructura)
      chunks.flat_map do |chunk|
        if chunk.length > limite
          chunk.scan(/.{1,#{limite}}(?=\s|\z)/m).reject(&:blank?)
        else
          [chunk]
        end
      end
    end

    # ================================================================
    # Normalización de espacios: NBSP real y entidad &nbsp residual
    # ================================================================
    def normalizar_espacios(texto)
      texto.gsub(/\u00A0/, ' ')      # NBSP decodificado del rich text
           .gsub(/&nbsp;?/i, ' ')    # entidad literal (Trix sin decodificar o LLM)
    end

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