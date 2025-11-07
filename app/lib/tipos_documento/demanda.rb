# app/services/tipos_documento/demanda.rb
module TiposDocumento
  class Demanda < TipoDocumento

    def initialize(service, texto_extraido = nil)
      super(service)
      @texto_extraido = texto_extraido
    end

    def procesar!
      texto = @texto_extraido || @service.send(:extraer_texto_pdf)
      return false if texto.blank?

      # 1. Extraer participantes (puede fallar, pero continuamos)
      participantes = extraer_participantes(texto)
      unless participantes
        Rails.logger.warn('[Demanda] ⚠️  Participants extraction failed, using empty hash')
        participantes = { 'demandantes' => [], 'demandados' => [], 'testigos' => [] }
      end

      # 2. Asignar identificadores (siempre ejecutado)
      asignar_identificadores(participantes)

      # 3. Crear metadatas (NUEVO: reemplaza ActTexto de participantes)
      crear_metadata_participantes(participantes)  # Código 'cdgs'
      crear_metadata_denunciantes(texto, participantes) # Código 'vlrs'

      # 4. Generar textos restantes (sin metadata de participantes)
      generar_resumen_anonimizado(texto)
      generar_lista_hechos(texto)

      true
    end

    private

    # ----------  PARTICIPANTES (extracción) ----------
    def extraer_participantes(texto)
      prompt = build_participantes_prompt(texto)
      resp = chat(prompt)
      
      Rails.logger.info("[Demanda] 📨 Raw response: #{resp.inspect}")
      
      content = resp&.dig("choices", 0, "message", "content")
      return false if content.blank?
      
      safe_json_parse(content)
    end

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

    # ----------  METADATA: PARTICIPANTES (cdgs) ----------
    def crear_metadata_participantes(participantes)
      metadata = {
        participantes: participantes,
        identificadores: @identificadores,
        total_demandantes: participantes['demandantes']&.size || 0,
        total_demandados: participantes['demandados']&.size || 0,
        total_testigos: participantes['testigos']&.size || 0,
        generado_en: Time.current.iso8601
      }
      
      @service.act_archivo.act_metadatas.create!(
        act_metadata: 'cdgs',
        metadata: metadata
      )
    end

    # ----------  METADATA: DENUNCIANTES (vlrs) ----------
    def crear_metadata_denunciantes(texto, participantes)
      # 'denunciante' = 'demandante' en contexto laboral
      demandantes = participantes['demandantes'] || []
      return if demandantes.empty?
      
      datos_denunciantes = []
      
      demandantes.each do |demandante|
        datos_laborales = extraer_datos_laborales(texto, demandante['nombre'])
        next unless datos_laborales
        
        datos_denunciantes << {
          nombre: demandante['nombre'],
          identificacion: demandante['identificacion'],
          **datos_laborales,
          identificador_anonimizado: @identificadores[:demandantes][demandante['nombre']]
        }
      end
      
      return if datos_denunciantes.empty?
      
      @service.act_archivo.act_metadatas.create!(
        act_metadata: 'vlrs',
        metadata: {
          denunciantes: datos_denunciantes,
          total_registros: datos_denunciantes.size,
          generado_en: Time.current.iso8601
        }
      )
    end

    def extraer_datos_laborales(texto, nombre_demandante)
      prompt = build_datos_laborales_prompt(texto, nombre_demandante)
      resp = chat(prompt)
      
      content = resp&.dig("choices", 0, "message", "content")
      return nil if content.blank?
      
      datos = safe_json_parse(content)
      return nil if datos.blank?
      
      # Validar que al menos tengamos un campo útil
      return nil if datos['cargo'].blank? && datos['fecha_inicio'].blank?
      
      datos.symbolize_keys
    rescue => e
      Rails.logger.error("[Demanda] ❌ Error extrayendo datos laborales para #{nombre_demandante}: #{e.message}")
      nil
    end

    def build_datos_laborales_prompt(texto, nombre_demandante)
      truncated = texto[0..4000]
      <<~PROMPT
        Analiza el siguiente texto de una demanda y extrae la información laboral específica para: **#{nombre_demandante}**

        Busca específicamente:
        1. Cargo o puesto desempeñado
        2. Fecha de inicio de relación laboral (formato: DD/MM/YYYY)
        3. Fecha de término de relación laboral (DD/MM/YYYY o "indeterminado")
        4. Remuneración (monto y moneda)

        Texto de la demanda:
        #{truncated}

        Devuelve JSON con esta estructura (usa null si no encuentras dato):
        {
          "cargo": "...",
          "fecha_inicio": "...",
          "fecha_termino": "...",
          "remuneracion": "..."
        }
      PROMPT
    end

    # ----------  RESUMEN ANONIMIZADO (ActTexto) ----------
    def generar_resumen_anonimizado(texto)
      prompt = build_resumen_prompt(texto)
      resp = chat(prompt)
      
      Rails.logger.info("[Demanda] 📨 Raw response: #{resp.inspect}")
      
      content = resp&.dig("choices", 0, "message", "content")
      return false if content.blank?
      
      # ✅ DESPUÉS:
      @service.send(:crear_act_texto,
        tipo: "resumen_anonimizado",
        titulo: "Resumen Anonimizado – Demanda #{@service.act_archivo.id}",
        contenido: formatear_html(content)
      )
    end

    def build_resumen_prompt(texto)
      truncated = texto[0..6000]
      <<~PROMPT
        Basándote en el siguiente texto de demanda, crea un resumen que incluya:

        1. Identificación de demandantes (usa los identificadores: #{@identificadores[:demandantes].to_json})
        2. Montos demandados detallados por concepto

        Texto de la demanda:
        #{truncated}

        Devuelve el resumen en formato de texto estructurado.
      PROMPT
    end

    # ----------  LISTA DE HECHOS (ActTexto) ----------
    def generar_lista_hechos(texto)
      prompt = build_hechos_prompt(texto)
      resp = chat(prompt)
      
      Rails.logger.info("[Demanda] 📨 Raw response: #{resp.inspect}")
      
      content = resp&.dig("choices", 0, "message", "content")
      return false if content.blank?
      
      # ✅ DESPUÉS:
      @service.send(:crear_act_texto,
        tipo: "lista_hechos",
        titulo: "Lista de Hechos – Demanda #{@service.act_archivo.id}",
        contenido: formatear_html(content)
      )
    end

    def build_hechos_prompt(texto)
      truncated = texto[0..6000]
      <<~PROMPT
        Extrae del siguiente texto de demanda todos los hechos fundamentales.

        Para cada hecho:
        1. Identifica la fecha (si existe)
        2. Extrae la descripción completa del hecho
        3. Anonimiza los nombres usando estos identificadores: #{@identificadores.to_json}

        Presenta los hechos con este formato:
        ===
        FECHA: [fecha del hecho]
        HECHO: [descripción anonimizada del hecho]
        ===

        Texto de la demanda:
        #{truncated}
      PROMPT
    end

    # ----------  IDENTIFICADORES ----------
    def asignar_identificadores(participantes)
      @identificadores = { demandantes: {}, demandados: {}, testigos: {} }
      contadores = { demandantes: 0, demandados: 0, testigos: 0 }

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

      @service.instance_variable_set(:@identificadores, @identificadores)
    end

    # ----------  UTILITIES ----------
#    def crear_act_texto(props)
#      @service.act_archivo.act_textos.create!(
#        tipo_documento: props[:tipo],
#        titulo: props[:titulo],
#        notas: props[:contenido],
#        metadata: {}
#      )
#    end

    # ✅ DESPUÉS:
    def formatear_html(inner)
      <<~HTML
        <div class="prose max-w-none">
          #{inner}
        </div>
      HTML
    end

    def safe_json_parse(str)
      JSON.parse(str)
    rescue JSON::ParserError
      { "demandantes" => [], "demandados" => [], "testigos" => [] }
    end

    # DESPUÉS:
    def chat(prompt)
      @service.send(:chat_with_retry, prompt)
    end

  end
end