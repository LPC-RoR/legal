class ActArchivo < ApplicationRecord
  attr_accessor :skip_pdf_presence

  belongs_to :ownr, polymorphic: true, optional: true

  belongs_to :anonimizado_de, class_name: 'ActArchivo', optional: true
  has_one    :anonimizado_como, class_name: 'ActArchivo',
  foreign_key: 'anonimizado_de_id', dependent: :destroy

  has_one_attached :pdf
  has_many :act_textos, dependent: :destroy
  has_many :act_metadatas, dependent: :destroy

  MAX_PDF_SIZE = 20.megabytes

  validate :pdf_valid, unless: -> {self.rlzd}
  validate :safe_pdf, unless: -> {self.rlzd}
  validate :pdf_must_be_attached_unless_rlzd

  validates :fecha, presence: true, if: -> { mdl.present? && mdl.constantize.try(:act_fecha, act_archivo) }
  validates_presence_of :act_archivo
  validates :nombre, presence: true, if: -> { mdl.present? && mdl.constantize.try(:act_lst?, act_archivo) }

  scope :originales,   -> { where(anonimizado: false) }
  scope :anonimizados, -> { where(anonimizado: true) }

  scope :act_ordr, -> { order(:act_archivo) }
  scope :crtd_ordr, -> { order(created_at: :desc) }
  scope :fecha_ordr, -> { order(:fecha) }

  scope :with_attached_pdf, -> { includes(pdf_attachment: :blob) }

#  after_create :procesar_demanda, if: :es_demanda?
  # Cambiar after_create por after_commit
  after_commit :procesar_demanda, on: :create, if: :es_demanda?
  after_commit :generar_metadata_anonimizacion, on: [:create, :update]

  # Métodos para acceder fácilmente a los textos
  def lista_participantes_texto
    act_textos.lista_participantes.first
  end

  def resumen_anonimizado_texto
    act_textos.resumen_anonimizado.first
  end

  def lista_hechos_texto
    act_textos.lista_hechos.first
  end

  def pdf_para(modo = :original)
    case modo
    when :anonimizado
      anonimizado_como || self
    else
      self
    end
  end

    # Add processing status methods
  def processing_status
    self[:processing_status] || 'pending'
  end

  def mark_processing!
    update_column(:processing_status, 'processing')
    Rails.logger.info("[ActArchivo] 🏷️ Marked as processing: #{id}")
  end

  def mark_completed!
    update_columns(
      processing_status: 'completed',
      processed_at: Time.current
    )
    Rails.logger.info("[ActArchivo] ✅ Marked as completed: #{id}")
  end

  def mark_failed!
    update_column(:processing_status, 'failed')
    Rails.logger.info("[ActArchivo] ❌ Marked as failed: #{id}")
  end

  # --------------------------------------------------------------------------------------------- ANONIMIZACIÓN
  def annmzbl?
    ['denuncia', 'declaracion', 'demanda'].include?(act_archivo)
  end

  def anonimizar_contenido
    return unless pdf.attached? && act_metadatas.exists?(act_metadata: 'cdgs_prtcpnts')
    
    contenido = extraer_texto_pdf(pdf) # Usa gem como pdf-reader o combine_pdf
    
    # 1. Reemplazos directos (match exacto)
    codigos = act_metadatas.find_by(act_metadata: 'cdgs_prtcpnts').metadata
    contenido = reemplazar_exactos(contenido, codigos)
    
    # 2. RegExp para casos predecibles (RUTs, emails)
    contenido = reemplazar_regex(contenido, codigos)
    
    # 3. LLM fallback para nombres parciales (opcional)
    if tiene_coincidencias_sospechosas?(contenido, codigos)
      contenido = anonimizar_con_llm(contenido, codigos)
    end
    
    generar_pdf_anonimizado(contenido)
  end

  # app/models/act_archivo.rb
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
    Rails.logger.info "🤖 Usando LLM para placeholders (PDF probablemente con placeholders)"
    
    contenido_anonimizado = anonimizar_con_llm_plchldrs(contenido, codigos)
    
    if contenido_anonimizado == contenido
      Rails.logger.warn "⚠️ LLM no hizo cambios"
      return nil
    end
    
    pdf_tempfile = generar_pdf_prawn(contenido_anonimizado)
    crear_registro_anonimizado(pdf_tempfile)
  end

  # Mejora el LLM con prompt más específico
  def anonimizar_nombres_con_llm(texto, nombres_codigos)
    return texto if nombres_codigos.empty?
    
    # Filtrar nombres cortos
    nombres_validos = nombres_codigos.reject { |nombre, _| nombre.strip.length < 3 }
    
    # Formato claro para LLM
    mapeo = nombres_validos.map do |nombre_real, metadata|
      "#{nombre_real.strip}|#{metadata[:codigo]}"
    end.join("\n")

    prompt = <<~PROMPT
      Reemplaza EXACTAMENTE estos nombres en el texto por sus códigos:
      
      #{mapeo}
      
      REGLAS:
      1. Reemplaza nombre completo, primer nombre o apellido
      2. Mantén formato, saltos de línea y puntuación
      3. Devuelve SOLO el texto anonimizado
      
      TEXTO:
      #{texto[0..3500]}
    PROMPT

    cliente = OpenAI::Client.new(
      access_token: Rails.application.credentials.dig(:openai, :api_key)
    )

    respuesta = cliente.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.0,
        max_tokens: 4000
      }
    )
    
    texto_anonimizado = respuesta.dig("choices", 0, "message", "content")
    texto_anonimizado&.strip || texto
  rescue => e
    Rails.logger.error "❌ Error LLM: #{e.message}"
    texto
  end

  # Método auxiliar para verificar configuración
  def self.verificar_openai
    key = Rails.application.credentials.dig(:openai, :api_key)
    if key.present?
      puts "✅ OpenAI API Key presente: #{key[0..10]}..."
      true
    else
      puts "❌ No se encontró openai:api_key en credentials"
      puts "   Ejecuta: rails credentials:edit"
      puts "   Y agrega:"
      puts "   openai:"
      puts "     api_key: sk-..."
      false
    end
  end

  def anonimizar_con_llm_plchldrs(texto, codigos)
    return texto if codigos.empty?
    
    # FORMA CORRECTA: Tu clave está en openai_api_key
    api_key = Rails.application.credentials.openai_api_key
    
    if api_key.blank?
      Rails.logger.error "❌ OPENAI_API_KEY no está configurada en credentials"
      Rails.logger.error "   Ejecuta: EDITOR=nano rails credentials:edit"
      Rails.logger.error "   Y agrega exactamente: openai_api_key: sk-..."
      return texto
    end

    # ✅ Manejar claves string y símbolo
    instrucciones = []
    codigos.each do |valor, metadata|
      tipo = metadata["tipo"] || metadata[:tipo]
      codigo = metadata["codigo"] || metadata[:codigo]
      
      next if valor.blank? || tipo.blank? || codigo.blank?
      
      instrucciones << "#{tipo.upcase}|#{valor}|#{codigo}"
    end

    # Evitar prompt vacío
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
    Rails.logger.debug "📄 Prompt: #{prompt[0..200]}..."

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
      Rails.logger.error "   Respuesta completa: #{respuesta.inspect}"
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

  # app/models/act_archivo.rb
  def generar_metadata_anonimizacion
    return unless ownr.is_a?(KrnDenuncia)
    return unless ['denuncia', 'declaracion'].include?(act_archivo)
    return unless pdf.attached?
    
    # CRUCIAL: Verificar que haya datos REALES
    datos_reales = ownr.krn_denunciantes.exists? || ownr.krn_denunciados.exists?
    return unless datos_reales
    
    hash_anonimizacion = ownr.cdgs_prtcpnts
    
    # Guardar solo si hay datos reales (detecta si el hash no es vacío)
    if hash_anonimizacion.any?
      metadata = act_metadatas.find_or_initialize_by(act_metadata: 'cdgs_prtcpnts')
      metadata.update!(metadata: hash_anonimizacion)
      Rails.logger.info "✅ Metadata generada con #{hash_anonimizacion.size} registros para PDF #{id}"
    else
      Rails.logger.warn "⚠️ No hay datos reales para generar metadata en PDF #{id}"
    end
  end

  def anonimizar_inteligente(texto, codigos)
    texto_original = texto.dup
    
    # Si no hay coincidencias exactas, usar LLM para placeholders
    coincidencias_exactas = codigos.any? { |valor, _| texto.include?(valor) }
    
    if coincidencias_exactas
      Rails.logger.info "📌 Usando reemplazo exacto"
      texto = reemplazar_exactos(texto, codigos)
    else
      Rails.logger.info "🤖 Usando LLM para placeholders"  # <-- CORREGIDO: quité el ) extra
      texto = anonimizar_con_llm_plchldrs(texto, codigos)
    end
    
    texto
  end

  # Método simple para otros campos
  def reemplazar_otros_simple(texto, otros_codigos)
    otros_codigos.each do |valor, metadata|
      next if valor.blank?
      texto.gsub!(valor.to_s, metadata[:codigo])
    end
    texto
  end

# --------------------------------------------------------------------------------------------- ANONIMIZACIÓN

private

  def es_demanda?
    act_archivo == "demanda"
  end

  def procesar_demanda
    ProcesadorDemandaJob.perform_later(self.id)
  end

  def pdf_must_be_attached_unless_rlzd
    return if rlzd || skip_pdf_presence
    errors.add(:pdf, "debe estar adjunto si no está realizado") unless pdf.attached?
  end

  def pdf_valid
    return unless pdf.attached?

    # 1. Validar contenido MIME real (no solo la extensión)
    unless pdf.content_type.in?(%w[application/pdf])
      errors.add(:pdf, "debe ser un archivo PDF")
      return
    end

    # 2. Validar tamaño máximo (ej. 5 MB)
    if pdf.byte_size > MAX_PDF_SIZE
      errors.add(:pdf, "supera el límite de #{MAX_PDF_SIZE / 1.megabyte}MB")
    end

    # 3. Validar extensión del archivo (doble seguridad)
    unless pdf.filename.to_s.downcase.end_with?('.pdf')
      errors.add(:pdf, "debe tener extensión .pdf")
    end

  end

  def safe_pdf
    return unless pdf.attached?

    pdf.open do |file|
      begin
        reader = PDF::Reader.new(file)

        if reader.page_count > 500
          errors.add(:pdf, 'tiene demasiadas páginas (máx. 500)')
          return
        end

        if reader.objects.any? { |_, obj| executable?(obj) }
          errors.add(:pdf, 'contiene código ejecutable no permitido')
          return
        end

      rescue PDF::Reader::MalformedPDFError
        errors.add(:pdf, 'está corrupto o no es un PDF válido')
      end
    end
  rescue ActiveStorage::FileNotFoundError
    # ignoramos: el archivo aún no está listo; lo validaremos después
  end

  def executable?(obj)
    return false unless obj.is_a?(Hash)
    obj[:JS] || obj[:S] == :JavaScript || obj[:Type] == :Action &&
      %i[Launch Sound Movie ResetForm ImportData].include?(obj[:S])
  end

  # ¿Está este documento se subió
  def self.act_archv_exst?(ownr, cdg)
    ActArchivo.exists?(ownr_type: ownr.class.name, ownr_id: ownr.id, cdg: cdg)
  end

  # --------------------------------------------------------------------------------------------- ANONIMIZACIÓN
  def extraer_texto(pdf_file)
    return "" unless pdf_file.attached?
    
    require 'pdf/reader'
    
    # FORMA CORRECTA: Descargar archivo temporalmente
    pdf_file.blob.open do |file|
      reader = PDF::Reader.new(file.path)
      text = reader.pages.map(&:text).join("\n")
      return text || ""
    end
  rescue => e
    Rails.logger.error "Error extrayendo PDF #{id}: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    ""
  end

  def reemplazar_exactos(texto, codigos)
    texto = texto.to_s
    return texto if texto.blank? || codigos.empty?

    reemplazos_realizados = 0
    
    # Ordena por longitud descendente
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

  def reemplazar_regex(texto, codigos)
    # RUT: "11.111.111-1", "11111111-1", "111111111"
    codigos.select { |_, m| m[:tipo] == :rut }.each do |valor, metadata|
      # Genera variantes del RUT
      rut_limpio = valor.gsub(/[\.-]/, '')
      variantes = [
        valor,                              # Original
        rut_limpio,                         # Sin puntos ni guión
        rut_limpio[0...-1] + '-' + rut_limpio[-1] # Con guión al final
      ].uniq
      
      regex = /\b(?:#{variantes.map { |v| Regexp.escape(v) }.join('|')})\b/i
      texto.gsub!(regex, metadata[:codigo])
    end
    texto
  end

  def crear_registro_anonimizado(pdf_tempfile)
    ActArchivo.transaction do
      # 1. Crear registro SALTÁNDOSE la validación
      anonimizado = ActArchivo.create!(
        ownr: ownr,
        act_archivo: 'anonimizado',
        anonimizado_de: self,
        skip_pdf_presence: true  # <-- CLAVE: evita la validación
      )
      
      # 2. Adjuntar PDF después
      pdf_tempfile.rewind
      anonimizado.pdf.attach(
        io: File.open(pdf_tempfile.path),
        filename: "anonimizado_#{pdf.filename}",
        content_type: 'application/pdf'
      )
      
      pdf_tempfile.close
      pdf_tempfile.unlink
      
      anonimizado
    end
  end

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
