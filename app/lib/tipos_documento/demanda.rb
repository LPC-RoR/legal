# app/services/tipos_documento/demanda.rb
module TiposDocumento
  class Demanda < TipoDocumento

    def procesar!
      texto = @service.send(:extraer_texto_pdf)
      return false if texto.blank?

      # 1. participantes (extrae + anonimiza)
      participantes = generar_lista_participantes(texto)
      # Si participantes es false ⇒ falló OpenAI, pero debemos **seguir**
      unless participantes
        Rails.logger.warn('[Demanda] ⚠️  Participants extraction failed, using empty hash')
        participantes = { 'demandantes' => [], 'demandados' => [], 'testigos' => [] }
      end

      # 2. siempre asigna identificadores (aunque sea vacío)
      asignar_identificadores(participantes)

      # 3. resto de pasos
      generar_resumen_anonimizado(texto)
      generar_lista_hechos(texto)

      true
    end

    private

    # ----------  PARTICIPANTES  ----------
    def generar_lista_participantes(texto)
      prompt = build_participantes_prompt(texto)
      resp   = chat(prompt)

      Rails.logger.info("[Demanda] 📨 Raw response: #{resp.inspect}")

      content = resp&.dig("choices", 0, "message", "content")
      if content.blank?
        Rails.logger.error("[Demanda] ❌ No content received")
        return false
      end

      participantes = safe_json_parse(content)
      asignar_identificadores(participantes)   # siempre ejecutado
      doc = crear_documento_participantes(participantes)

      crear_act_texto(
        tipo:      "lista_participantes",
        titulo:    "Lista de Participantes – Demanda #{@service.act_archivo.id}",
        contenido: formatear_html("<pre>#{doc}</pre>")
      )

      participantes
    end

    # ----------  RESUMEN ANONIMIZADO  ----------
    def generar_resumen_anonimizado(texto)
      prompt = build_resumen_prompt(texto)
      resp   = chat(prompt)
      Rails.logger.info("[Demanda] 📨 Raw response: #{resp.inspect}")
      content = resp&.dig("choices", 0, "message", "content")
      if content.blank?
        Rails.logger.error("[Demanda] ❌ No content received")
        return false
      end

      crear_act_texto(
        tipo:      "resumen_anonimizado",
        titulo:    "Resumen Anonimizado – Demanda #{@service.act_archivo.id}",
        contenido: formatear_html(content)
      )
    end

    # ----------  LISTA DE HECHOS  ----------
    def generar_lista_hechos(texto)
      prompt = build_hechos_prompt(texto)
      resp   = chat(prompt)
      Rails.logger.info("[Demanda] 📨 Raw response: #{resp.inspect}")
      content = resp&.dig("choices", 0, "message", "content")
      if content.blank?
        Rails.logger.error("[Demanda] ❌ No content received")
        return false
      end

      crear_act_texto(
        tipo:      "lista_hechos",
        titulo:    "Lista de Hechos – Demanda #{@service.act_archivo.id}",
        contenido: formatear_html(resp.dig(content))
      )
    end

    # ----------  PROMPTS  ----------
    def build_participantes_prompt(texto)
      truncated = texto[0..6000]
      <<~PROMPT
        Analiza el siguiente texto de una demanda legal y extrae:
        1. Todos los demandantes con sus cédulas/RUN/RUT
        2. Todos los demandados con sus cédulas/RUN/RUT
        3. Todos los testigos con sus cédulas/RUN/RUT

        Para cada persona necesito:
        - Nombre completo
        - Cédula de identidad/RUN/RUT
        - Rol (demandante/demandado/testigo)

        Texto de la demanda:
        #{truncated}

        Devuelve la información en formato JSON con esta estructura:
        {
          "demandantes": [{"nombre": "...", "identificacion": "..."}],
          "demandados":  [{"nombre": "...", "identificacion": "..."}],
          "testigos":    [{"nombre": "...", "identificacion": "..."}]
        }

        Si no hay datos para alguna categoría, devuelve array vacío.
      PROMPT
    end

    def build_resumen_prompt(texto)
      truncated = texto[0..6000]
      <<~PROMPT
        Basándote en el siguiente texto de demanda, crea un resumen que incluya:

        1. Identificación de demandantes (usa los identificadores proporcionados)
        2. Montos demandados detallados por concepto

        Usa estos identificadores para anonimizar:
        #{@identificadores[:demandantes].to_json}

        Texto de la demanda:
        #{truncated}

        Devuelve el resumen en formato de texto estructurado.
      PROMPT
    end

    def build_hechos_prompt(texto)
      truncated = texto[0..6000]
      <<~PROMPT
        Extrae del siguiente texto de demanda todos los hechos fundamentales.

        Para cada hecho:
        1. Identifica la fecha (si existe)
        2. Extrae la descripción completa del hecho
        3. Anonimiza los nombres usando estos identificadores:
           #{@identificadores.to_json}

        Presenta los hechos con este formato:
        ===
        FECHA: [fecha del hecho]
        HECHO: [descripción anonimizada del hecho]
        ===

        Texto de la demanda:
        #{truncated}
      PROMPT
    end

    # ----------  IDENTIFICADORES  ----------
    def asignar_identificadores(participantes)
      @identificadores = { demandantes: {}, demandados: {}, testigos: {} }
      contadores       = { demandantes: 0, demandados: 0, testigos: 0 }

      %w[demandantes demandados testigos].each do |rol|
        participantes[rol]&.each do |p|
          contadores[rol.to_sym] += 1
          prefix = case rol
                   when "demandantes" then "DNNCNT"
                   when "demandados"  then "DNNCD"
                   when "testigos"    then "TSTG"
                   end
          @identificadores[rol.to_sym][p["nombre"]] = "#{prefix}-#{contadores[rol.to_sym]}"
        end
      end

      # lo dejamos disponible para los otros métodos
      @service.instance_variable_set(:@identificadores, @identificadores)
    end

    # ----------  DOC & FORMAT  ----------
    def crear_documento_participantes(participantes)
      lines = []
      lines << "LISTA DE PARTICIPANTES - DEMANDA"
      lines << "====================================="
      %w[demandantes demandados testigos].each do |rol|
        lines << ""
        lines << "#{rol.upcase}:"
        participantes[rol]&.each do |p|
          id = @identificadores[rol.to_sym][p["nombre"]]
          lines << "- #{id}: #{p["nombre"]} – #{p["identificacion"]}"
        end
      end
      lines.join("\n")
    end

    def formatear_html(inner)
      <<~HTML
        <h1>#{inner}</h1>
        <hr>
        #{inner}
      HTML
    end

    def safe_json_parse(str)
      JSON.parse(str)
    rescue JSON::ParserError
      { "demandantes" => [], "demandados" => [], "testigos" => [] }
    end
  end
end