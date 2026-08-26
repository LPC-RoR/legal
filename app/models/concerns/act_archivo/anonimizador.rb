# app/models/concerns/act_archivo/anonimizador.rb
module ActArchivo::Anonimizador
  extend ActiveSupport::Concern

  # --------------------------------------------------------------
  # Verificación
  # --------------------------------------------------------------
  def annmzbl?
    ['denuncia', 'declaracion', 'demanda'].include?(act_archivo)
  end

  # --------------------------------------------------------------
  # Flujo principal: genera el PDF anonimizado y el registro hijo
  # --------------------------------------------------------------
  def generar_pdf_anonimizado!
    return unless pdf.attached?

    metadata_registro = act_metadatas.find_by(act_metadata: 'cdgs_prtcpnts')
    return unless metadata_registro

    codigos = metadata_registro.metadata
    return if codigos.nil? || codigos.empty?
    return if anonimizado_como.present?

    contenido = extraer_texto(pdf)
    return nil if contenido.blank?

    Rails.logger.info "🔍 PDF #{id}: Metadata contiene #{codigos.size} registros"
    Rails.logger.info "🤖 Usando LLM para placeholders"

    contenido_anonimizado = anonimizar_con_llm_plchldrs(contenido, codigos)

    if contenido_anonimizado == contenido
      Rails.logger.warn "⚠️ LLM no hizo cambios"
      return nil
    end

    pdf_tempfile = generar_pdf_prawn(contenido_anonimizado)
    crear_registro_anonimizado(pdf_tempfile)
  end

  # --------------------------------------------------------------
  # Anonimización inteligente (público para uso manual)
  # --------------------------------------------------------------
  def anonimizar_inteligente(texto, codigos)
    coincidencias_exactas = codigos.any? { |valor, _| texto.include?(valor) }

    if coincidencias_exactas
      Rails.logger.info "📌 Usando reemplazo exacto"
      reemplazar_exactos(texto, codigos)
    else
      Rails.logger.info "🤖 Usando LLM para placeholders"
      anonimizar_con_llm_plchldrs(texto, codigos)
    end
  end

  # --------------------------------------------------------------
  # LLM con placeholders
  # --------------------------------------------------------------
  def anonimizar_con_llm_plchldrs(texto, codigos)
    return texto if codigos.empty?

    api_key = Rails.application.credentials.openai_api_key

    if api_key.blank?
      Rails.logger.error "❌ OPENAI_API_KEY no está configurada en credentials"
      return texto
    end

    instrucciones = []
    codigos.each do |valor, metadata|
      tipo   = metadata["tipo"]   || metadata[:tipo]
      codigo = metadata["codigo"] || metadata[:codigo]

      next if valor.blank? || tipo.blank? || codigo.blank?

      instrucciones << "#{tipo.upcase}|#{valor}|#{codigo}"
    end

    if instrucciones.empty?
      Rails.logger.error "❌ No hay instrucciones válidas para LLM"
      return texto
    end

    prompt = <<~PROMPT
      Reemplaza estos datos en el texto por los códigos:

      FORMATO: TIPO|valor|CÓDIGO
      #{instrucciones.join("\n")}

      TEXTO:
      #{texto[0..2500]}

      REGLAS:
      1. Reemplaza nombres completos, parciales o placeholders tipo "Denunciante Pérez"
      2. Reemplaza RUTs en cualquier formato con/sin puntos
      3. Devuelve SOLO el texto con códigos, sin explicaciones
    PROMPT

    Rails.logger.info "🤖 Enviando prompt a OpenAI (#{instrucciones.size} instrucciones)"

    cliente = OpenAI::Client.new(access_token: api_key)

    respuesta = cliente.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.0,
        max_tokens: 4000
      }
    )

    texto_anonimizado = respuesta.dig("choices", 0, "message", "content")

    if texto_anonimizado.blank?
      Rails.logger.error "❌ LLM devolvió respuesta vacía"
      return texto
    end

    texto_anonimizado.strip
  rescue OpenAI::Error => e
    Rails.logger.error "❌ Error OpenAI: #{e.message}"
    texto
  rescue => e
    Rails.logger.error "❌ Error inesperado: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    texto
  end

  # --------------------------------------------------------------
  # Genera/actualiza la metadata de anonimización
  # --------------------------------------------------------------
  def generar_metadata_anonimizacion
    return unless ownr.is_a?(KrnDenuncia)
    return unless ['denuncia', 'declaracion'].include?(act_archivo)
    return unless pdf.attached?

    datos_reales = ownr.krn_denunciantes.exists? || ownr.krn_denunciados.exists?
    return unless datos_reales

    hash_anonimizacion = ownr.cdgs_prtcpnts

    if hash_anonimizacion.any?
      metadata = act_metadatas.find_or_initialize_by(act_metadata: 'cdgs_prtcpnts')
      metadata.update!(metadata: hash_anonimizacion)
      Rails.logger.info "✅ Metadata generada con #{hash_anonimizacion.size} registros para PDF #{id}"
    else
      Rails.logger.warn "⚠️ No hay datos reales para generar metadata en PDF #{id}"
    end
  end

  private

  # --------------------------------------------------------------
  # Extracción de texto
  # --------------------------------------------------------------
  def extraer_texto(pdf_file)
    return "" unless pdf_file.attached?

    require 'pdf/reader'

    pdf_file.blob.open do |file|
      reader = PDF::Reader.new(file.path)
      text = reader.pages.map(&:text).join("\n")
      text || ""
    end
  rescue => e
    Rails.logger.error "Error extrayendo PDF #{id}: #{e.message}"
    ""
  end

  # --------------------------------------------------------------
  # Reemplazos exactos (por palabra completa)
  # --------------------------------------------------------------
  def reemplazar_exactos(texto, codigos)
    texto = texto.to_s
    return texto if texto.blank? || codigos.empty?

    reemplazos_realizados = 0

    # Ordena por longitud descendente para evitar reemplazos parciales
    codigos.sort_by { |k, _| -k.to_s.length }.each do |valor, metadata|
      next if metadata[:codigo].blank?
      next if valor.to_s.strip.blank?

      pattern = Regexp.escape(valor.to_s)
      ocurrencias = texto.scan(/\b#{pattern}\b/i).size

      if ocurrencias > 0
        texto.gsub!(/\b#{pattern}\b/i, metadata[:codigo])
        reemplazos_realizados += ocurrencias
        Rails.logger.info "  🔁 Reemplazado '#{valor}' → '#{metadata[:codigo]}' (#{ocurrencias} ocurrencias)"
      end
    end

    Rails.logger.info "  📈 Total reemplazos: #{reemplazos_realizados}"
    texto
  end

  # --------------------------------------------------------------
  # Reemplazos por regex (RUTs en variantes)
  # --------------------------------------------------------------
  def reemplazar_regex(texto, codigos)
    codigos.select { |_, m| m[:tipo] == :rut }.each do |valor, metadata|
      rut_limpio = valor.gsub(/[\.-]/, '')
      variantes = [
        valor,
        rut_limpio,
        rut_limpio[0...-1] + '-' + rut_limpio[-1]
      ].uniq

      regex = /\b(?:#{variantes.map { |v| Regexp.escape(v) }.join('|')})\b/i
      texto.gsub!(regex, metadata[:codigo])
    end
    texto
  end

  # --------------------------------------------------------------
  # Creación del registro anonimizado
  # --------------------------------------------------------------
  def crear_registro_anonimizado(pdf_tempfile)
    ActArchivo.transaction do
      pdf_tempfile.rewind

      anonimizado = ActArchivo.create!(
        ownr: ownr,
        act_archivo: 'anonimizado',
        anonimizado_de: self,
        pdf: {
          io: File.open(pdf_tempfile.path),
          filename: "anonimizado_#{pdf.filename}",
          content_type: 'application/pdf'
        }
      )

      pdf_tempfile.close
      pdf_tempfile.unlink

      anonimizado
    end
  end

  # --------------------------------------------------------------
  # Generación del PDF con Prawn
  # --------------------------------------------------------------
  def generar_pdf_prawn(contenido)
    require 'prawn'

    pdf_tempfile = Tempfile.new(['anonimizado', '.pdf'])

    Prawn::Document.generate(pdf_tempfile.path) do |pdf|
      pdf.font "Helvetica", size: 11
      pdf.text "DOCUMENTO ANONIMIZADO",
               align: :center, style: :bold, size: 14
      pdf.move_down 20
      pdf.text contenido, leading: 2, inline_format: true
      pdf.move_down 30
      pdf.text "Generado el #{Time.current.strftime('%d/%m/%Y %H:%M')}",
               size: 8, align: :right
    end

    pdf_tempfile
  end
end