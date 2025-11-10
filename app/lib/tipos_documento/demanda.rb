# app/lib/tipos_documento/demanda.rb
module TiposDocumento
  class Demanda < TipoDocumento

    def initialize(service, texto_extraido = nil)
      super(service)
      @texto_extraido = texto_extraido
    end

    def procesar!
      texto = @texto_extraido || @service.send(:extraer_texto_pdf)
      return false if texto.blank?

      # 1. Extraer participantes
      participantes = extraer_participantes(texto)
      unless participantes
        Rails.logger.warn('[Demanda] ⚠️  Participants extraction failed, using empty hash')
        participantes = { 'demandantes' => [], 'demandados' => [], 'testigos' => [] }
      end

      # 2. Asignar identificadores (CRÍTICO)
      asignar_identificadores(participantes)

      # 3. Crear metadatas
      crear_metadata_participantes(participantes)  # Código 'cdgs'
      crear_metadata_denunciantes(texto, participantes) # Código 'vlrs'

      # 4. Generar textos restantes
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
      
      # Usa el safe_json_parse del padre (que limpia ```json)
      safe_json_parse(content)
    end

    def build_participantes_prompt(texto)
      # Solo el encabezado donde están los datos personales
      truncated = texto[0..2500]
      <<~PROMPT
        Analiza el siguiente texto de una demanda legal y extrae:
        1. Todos los demandantes con sus cédulas/RUN/RUT
        2. Todos los demandados con sus cédulas/RUN/RUT
        3. Todos los testigos con sus cédulas/RUN/RUT

        Para cada persona necesito:
        - Nombre completo
        - Cédula de identidad/RUN/RUT
        - Rol (demandante/demandado/testigo)

        Texto del encabezado:
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
      participantes_norm = participantes.deep_transform_keys(&:to_s)
      participantes_norm.each do |rol, lista|
        participantes_norm[rol] = lista.map { |p| p.transform_keys(&:to_s) }
      end
      
      # CRÍTICO: Verifica que @identificadores existe
      unless defined?(@identificadores) && @identificadores
        Rails.logger.error("[Demanda] ❌ @identificadores no está definido en crear_metadata_participantes")
        @identificadores = { demandantes: {}, demandados: {}, testigos: {} }
      end
      
      metadata = {
        participantes: participantes_norm,
        identificadores: @identificadores,
        total_demandantes: participantes_norm['demandantes']&.size || 0,
        total_demandados: participantes_norm['demandados']&.size || 0,
        total_testigos: participantes_norm['testigos']&.size || 0,
        generado_en: Time.current.iso8601
      }
      
      @service.act_archivo.act_metadatas.create!(
        act_metadata: 'cdgs',
        metadata: metadata
      )
      
      Rails.logger.info("[Demanda] ✅ Metadata participantes creada: #{metadata.inspect}")
    end

    # ----------  METADATA: DENUNCIANTES (vlrs) ----------
    def crear_metadata_denunciantes(texto, participantes)
      # Normaliza participantes
      participantes = participantes.deep_stringify_keys if participantes.respond_to?(:deep_stringify_keys)
      demandantes = participantes['demandantes'] || []
      
      if demandantes.empty?
        Rails.logger.warn("[Demanda] ⚠️ No hay demandantes para crear metadata vlrs")
        return
      end
      
      Rails.logger.info("[Demanda] 📊 Procesando #{demandantes.size} demandantes para metadata vlrs")
      
      datos_denunciantes = []
      
      demandantes.each_with_index do |demandante, index|
        nombre = demandante["nombre"]&.strip
        if nombre.blank?
          Rails.logger.warn("[Demanda] ⚠️ Demandante #{index} sin nombre, saltando")
          next
        end
        
        Rails.logger.info("[Demanda] 🔍 Buscando datos laborales para: #{nombre}")
        
        datos_laborales = extraer_datos_laborales(texto, nombre)
        
        if datos_laborales.nil?
          Rails.logger.warn("[Demanda] ⚠️ No se encontraron datos laborales para #{nombre}")
          # Usa datos vacíos para no perder el registro
          datos_laborales = { cargo: nil, fecha_inicio: nil, fecha_termino: nil, remuneracion: nil }
        end
        
        # Obtiene identificador anonimizado
        identificador = @identificadores[:demandantes][nombre.upcase]
        if identificador.nil?
          Rails.logger.warn("[Demanda] ⚠️ No hay identificador para #{nombre.upcase}")
          identificador = "DNNCNT-#{index + 1}"
        end
        
        datos_denunciantes << {
          nombre: nombre,
          identificacion: demandante["identificacion"],
          **datos_laborales,
          identificador_anonimizado: identificador
        }
        
        Rails.logger.info("[Demanda] ✅ Datos guardados para #{nombre}: #{datos_denunciantes.last.inspect}")
      end
      
      return if datos_denunciantes.empty?
      
      metadata = {
        denunciantes: datos_denunciantes,
        total_registros: datos_denunciantes.size,
        generado_en: Time.current.iso8601
      }
      
      @service.act_archivo.act_metadatas.create!(
        act_metadata: 'vlrs',
        metadata: metadata
      )
      
      Rails.logger.info("[Demanda] ✅ Metadata vlrs creada con éxito: #{metadata.inspect}")
    end

    def extraer_datos_laborales(texto, nombre_demandante)
      # BUSCA EN TODO EL TEXTO, no solo el inicio
      # Los datos laborales pueden estar en cualquier parte
      prompt = build_datos_laborales_prompt(texto, nombre_demandante)
      resp = chat(prompt)
      
      content = resp&.dig("choices", 0, "message", "content")
      
      if content.blank?
        Rails.logger.warn("[Demanda] ⚠️ Contenido vacío de OpenAI para datos laborales de #{nombre_demandante}")
        return nil
      end
      
      Rails.logger.info("[Demanda] 📨 Respuesta datos laborales para #{nombre_demandante}: #{content[0..100]}...")
      
      datos = safe_json_parse(content)
      
      if datos.blank?
        Rails.logger.warn("[Demanda] ⚠️ JSON parse devolvío datos vacíos para #{nombre_demandante}")
        return nil
      end
      
      # RELAJA la validación: acepta datos parciales
      # Antes: return nil si cargo Y fecha_inicio están vacíos
      # Ahora: retorna los datos que tengamos
      datos.symbolize_keys
      
    rescue => e
      Rails.logger.error("[Demanda] ❌ Error extrayendo datos laborales para #{nombre_demandante}: #{e.message}\n#{e.backtrace[0..3].join("\n")}")
      nil
    end

    def build_datos_laborales_prompt(texto, nombre_demandante)
      # Usamos más texto para encontrar la info laboral
      # Puede estar en cualquier parte del documento
      texto_contexto = texto  # NO truncar, usar TODO el texto
      
      <<~PROMPT
        BUSCA INFORMACIÓN LABORAL para: **#{nombre_demandante}**
        
        Analiza TODO el siguiente texto de demanda y extrae:
        1. Cargo o puesto desempeñado
        2. Fecha de inicio de relación laboral (formato: DD/MM/YYYY)
        3. Fecha de término de relación laboral (DD/MM/YYYY o "indeterminado")
        4. Remuneración (monto y moneda)
        
        TEXTO COMPLETO DE LA DEMANDA:
        #{texto_contexto}
        
        Devuelve JSON con esta estructura (usa null si no encuentras dato):
        {
          "cargo": "...",
          "fecha_inicio": "...",
          "fecha_termino": "...",
          "remuneracion": "..."
        }
        
        IMPORTANTE: Si no encuentras algún dato, usa null pero DEVUELVE EL JSON.
      PROMPT
    end

    # ----------  RESUMEN ANONIMIZADO (ActTexto) ----------
    def generar_resumen_anonimizado(texto)
      seccion_peticiones = extraer_seccion_peticiones(texto)
      
      prompt = build_resumen_prompt(seccion_peticiones)
      resp = chat(prompt)
      
      content = resp&.dig("choices", 0, "message", "content")
      return false if content.blank?
      
      @service.send(:crear_act_texto,
        tipo: "resumen_anonimizado",
        titulo: "Resumen Anonimizado – Demanda #{@service.act_archivo.id}",
        contenido: content
      )
    end

    def build_resumen_prompt(seccion_peticiones)
      <<~PROMPT
        Extrae todos los montos monetarios de la siguiente sección de una demanda legal.
        
        TEXTO:
        ---
        #{seccion_peticiones}
        ---
        
        INSTRUCCIONES:
        1. Busca TODOS los valores en formato $[número]
        2. Para cada monto, EXTRAEL EL CONCEPTO COMPLETO que aparece en el texto
        3. Formato requerido: "CONCEPTO: $MONTO"
        4. NO uses placeholders como "Concepto 1"
        5. Ordena por aparición en el texto
        
        EJEMPLO:
        Indemnización sustitutiva de aviso previo: $1.343.906
        Indemnización por años de servicio: $8.063.436
        
        RESPUESTA (solo la lista, sin texto adicional):
      PROMPT
    end

    def extraer_seccion_peticiones(texto)
      # Busca "POR TANTO" seguido de "PIDO:"
      match = texto.match(/(POR\s+TANTO.*?PIDO:.*?)(?:\n\n|\z)/mi)
      return match[1] if match
      
      # Fallback: últimas 8000 chars
      texto[-8000..-1] || texto
    end

    # ----------  LISTA DE HECHOS (ActTexto) ----------
    def generar_lista_hechos(texto)
      prompt = build_hechos_prompt(texto)
      resp = chat(prompt)
      
      content = resp&.dig("choices", 0, "message", "content")
      return false if content.blank?
      
      @service.send(:crear_act_texto,
        tipo: "lista_hechos",
        titulo: "Lista de Hechos – Demanda #{@service.act_archivo.id}",
        contenido: content
      )
    end

    def build_hechos_prompt(texto)
      # Usa un prompt más simple y directo
      truncated = texto[0..6000]
      <<~PROMPT
        Extrae hechos fundamentales del texto, anonimiza nombres.
        
        Usa identificadores: #{@identificadores.to_json}
        
        Texto:
        #{truncated}
        
        Formato por hecho:
        FECHA: [fecha]
        HECHO: [descripción anonimizada]
      PROMPT
    end

    # ----------  IDENTIFICADORES ----------
    def asignar_identificadores(participantes)
      @identificadores = { demandantes: {}, demandados: {}, testigos: {} }
      contadores = { demandantes: 0, demandados: 0, testigos: 0 }

      # Normaliza participantes a string keys
      participantes = participantes.deep_stringify_keys if participantes.respond_to?(:deep_stringify_keys)
      
      %w[demandantes demandados testigos].each do |rol|
        participantes[rol]&.each do |p|
          contadores[rol.to_sym] += 1
          prefix = case rol
                   when "demandantes" then "DNNCNT"
                   when "demandados"  then "DNNCD"
                   when "testigos"    then "TSTG"
                   end
          
          # Normaliza el nombre para consistencia
          nombre = p["nombre"]&.strip&.upcase
          next if nombre.blank?
          
          @identificadores[rol.to_sym][nombre] = "#{prefix}-#{contadores[rol.to_sym]}"
        end
      end

      # CRÍTICO: Guarda en el servicio para que otros métodos lo usen
      @service.instance_variable_set(:@identificadores, @identificadores)
      Rails.logger.info("[Demanda] ✅ Identificadores asignados: #{@identificadores.inspect}")
    end

    # Usa el chat del padre
    def chat(prompt)
      @service.send(:chat_with_retry, prompt)
    end

  end
end