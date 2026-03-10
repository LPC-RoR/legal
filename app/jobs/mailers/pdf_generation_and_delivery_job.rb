# app/jobs/mailers/pdf_generation_and_delivery_job.rb
class Mailers::PdfGenerationAndDeliveryJob < ApplicationJob
  queue_as :pdf_generation

  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(denuncia_id, rprt)
    setup_chromium_environment!
    
    denuncia = KrnDenuncia.find(denuncia_id)
    return unless denuncia

    context = :investigations
    
    set_active_storage_url_options!

    logo_path = obtener_ruta_imagen_logo(denuncia)
    sign_path = obtener_ruta_imagen_sign(denuncia)
    
    head_path = logo_path || Rails.root.join('public', 'mssgs', 'email_head.png').to_s
    sign_path_final = sign_path || Rails.root.join('public', 'mssgs', 'email_sign.png').to_s

    begin
      denuncia.krn_denunciantes.each do |dnncnt|
        process_denunciante(denuncia, rprt, dnncnt, context, head_path, sign_path_final)
      end
    ensure
      limpiar_temporales(logo_path) if logo_path.present?
      limpiar_temporales(sign_path) if sign_path.present?
    end
    
  rescue => e
    # En caso de error, limpiar el bloqueo para permitir reintento
    Rails.cache.delete("pdf_generation:#{denuncia_id}")
    raise
  ensure
    # Asegurar que se limpie el bloqueo al finalizar (éxito o fracaso)
    Rails.cache.delete("pdf_generation:#{denuncia_id}")
  end

  private

  def setup_chromium_environment!
    ENV['PUPPETEER_EXECUTABLE_PATH'] ||= `which chromium-browser`.strip.presence || `which chromium`.strip.presence || `which google-chrome`.strip.presence || `which google-chrome-stable`.strip.presence
    ENV['DISPLAY'] ||= ':99'
    ENV['LANG'] ||= 'es_CL.UTF-8'
    ENV['LC_ALL'] ||= 'es_CL.UTF-8'
    
    Rails.logger.debug "Chromium path: #{ENV['PUPPETEER_EXECUTABLE_PATH']}"
    Rails.logger.debug "Display: #{ENV['DISPLAY']}"
  end

  def obtener_ruta_imagen_logo(denuncia)
    return nil unless denuncia&.ownr&.logo&.attached?
    
    descargar_a_temporal(denuncia.ownr.logo)
  rescue => e
    Rails.logger.error "Error obteniendo logo: #{e.message}"
    nil
  end

  def obtener_ruta_imagen_sign(denuncia)
    return nil unless denuncia&.ownr&.sign&.attached?
    
    descargar_a_temporal(denuncia.ownr.sign)
  rescue => e
    Rails.logger.error "Error obteniendo sign: #{e.message}"
    nil
  end

  def descargar_a_temporal(blob)
    extension = blob.filename.extension || 'png'
    tempfile = Tempfile.new(['active_storage', ".#{extension}"])
    tempfile.binmode
    
    blob.download do |chunk|
      tempfile.write(chunk)
    end
    tempfile.rewind
    
    tempfile.path
  ensure
    tempfile.close if tempfile.respond_to?(:close) && !tempfile.closed?
  end

  def process_denunciante(denuncia, rprt, dnncnt, context, head_path, sign_path)

    # Se agrega rprt en el nombre del PDF
    filename = "#{rprt}_#{dnncnt.id}_#{Time.current.to_i}.pdf"

    krn_kywrd = dnncnt.kywrd[:krn]

    # Se agrega rprt
    html = generar_html_pdf(denuncia, rprt, dnncnt, context, head_path, sign_path, krn_kywrd)
    
    Rails.logger.info "HTML generado, longitud: #{html.length} caracteres"
    
    pdf_content = generar_pdf_con_grover(html, denuncia)
    
    Rails.logger.info "PDF generado, longitud: #{pdf_content&.length || 'NIL'} bytes"
    Rails.logger.info "Es PDF válido? #{pdf_content&.start_with?('%PDF')}"
    
    # Se agrega rprt
    act_archivo = crear_act_archivo(dnncnt, rprt, pdf_content, filename)
    
    optn_email = dnncnt.tiene_email_validado? || dnncnt.tiene_email_verificado?
    optn_certf = dnncnt.articulo_516?

    if !optn_certf && optn_email
      # Se agrega rprt
      enviar_pdf_por_correo(denuncia, rprt, dnncnt, act_archivo, filename, context)
    end
  rescue => e
    Rails.logger.error "Error procesando denunciante #{dnncnt.id}: #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n")
    raise
  end

  def limpiar_temporales(path)
    return if path.blank?
    return if path.to_s.start_with?(Rails.root.join('public').to_s)
    
    File.delete(path) if File.exist?(path)
  rescue => e
    Rails.logger.error "Error eliminando temporal #{path}: #{e.message}"
  end

  def generar_html_pdf(objeto, rprt, dnncnt, context, head_path, sign_path, krn_kywrd)
    recipient = OpenStruct.new(
      email: dnncnt.email,
      nombre: dnncnt.nombre
    )

    branding = objeto.ownr&.tenant&.branding_for(context)
    
    head_url = imagen_a_data_url(head_path)
    sign_url = imagen_a_data_url(sign_path)

    html = ApplicationController.render(
      # rprt se usa para encontrar el template del PDF
      template: "mailers/contexts/investigations/document/#{rprt}_pdf",
      layout: 'mailers/pdf/base',
      assigns: {
        record: objeto,
        prtcpnt: dnncnt,
        recipient: recipient,
        branding: branding,
        logo_url: head_url,
        head_url: head_url,
        sign_url: sign_url,
        krn_kywrd: krn_kywrd,
        info_obligatoria: nil,
        plazo_dias: 15
      }
    )

    html = html.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    
    unless html.include?('<meta charset="UTF-8">')
      html = html.sub(/<head>/i, '<head><meta charset="UTF-8">')
    end

    html
  end

  def imagen_a_data_url(path)
    return nil unless path.present? && File.exist?(path)
    
    data = File.binread(path)
    mime_type = Marcel::MimeType.for(Pathname.new(path)) || 'image/png'
    base64 = Base64.strict_encode64(data)
    
    "data:#{mime_type};base64,#{base64}"
  rescue => e
    Rails.logger.error "Error convirtiendo imagen a data URL #{path}: #{e.message}"
    nil
  end

  def set_active_storage_url_options!
    config = Rails.application.config.action_mailer.default_url_options || {}
    
    ActiveStorage::Current.url_options = {
      host: config[:host] || 'localhost',
      port: config[:port] || 3000,
      protocol: config[:protocol] || 'http'
    }
  end

  # CORREGIDO: Argumentos de palabra clave, no un hash
  def generar_pdf_con_grover(html, objeto = nil)
    empresa = objeto&.ownr
    razon_social = empresa&.razon_social || "Empresa"
    fecha = I18n.l(Time.current, format: :long)

    footer_template = <<-HTML
      <div style="font-size: 8pt; font-family: 'Open Sans', sans-serif; 
                  width: 100%; padding: 0 15mm; margin-bottom: 10mm;
                  display: flex; justify-content: space-between; align-items: center;">
        <span style="color: #adb5bd;">#{razon_social}</span>
        <span style="color: #adb5bd; font-size: 7pt;">#{fecha}</span>
      </div>
    HTML

    # CORREGIDO: Argumentos de palabra clave individuales, NO un hash
    Grover.new(html,
      format: 'Letter',
      margin: {
        top: '15mm',
        bottom: '15mm',
        left: '15mm',
        right: '15mm'
      },
      print_background: true,
      prefer_css_page_size: false,
      emulate_media: 'print',
      wait_until: 'networkidle0',
      display_url: Rails.application.routes.url_helpers.root_url(
        host: ActiveStorage::Current.url_options[:host],
        port: ActiveStorage::Current.url_options[:port],
        protocol: ActiveStorage::Current.url_options[:protocol]
      ),
      header_template: ' ',
      footer_template: footer_template,
      launch_args: [
        '--no-sandbox', 
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-accelerated-2d-canvas',
        '--no-first-run',
        '--no-zygote',
        '--single-process',
        '--disable-gpu'
      ]
    ).to_pdf
  rescue => e
    Rails.logger.error "Error en Grover: #{e.class} - #{e.message}"
    Rails.logger.error "HTML length: #{html.length}"
    raise
  end

  def crear_act_archivo(dnncnt, rprt, pdf_content, filename)

    raise "PDF content es nil" if pdf_content.nil?
    raise "PDF content está vacío" if pdf_content.empty?
    raise "PDF content no es String" unless pdf_content.is_a?(String)
    raise "PDF no válido (no empieza con %PDF)" unless pdf_content.start_with?('%PDF')

    ActArchivo.transaction do
      act_archivo = ActArchivo.new(
        ownr: dnncnt,
        act_archivo: rprt,
        nombre: "Información Obligatoria - Denuncia #{dnncnt.krn_denuncia&.id}",
        tipo: 'pdf',
      )

      act_archivo.pdf.attach(
        io: StringIO.new(pdf_content),
        filename: filename,
        content_type: 'application/pdf'
      )

      act_archivo.save!
      
      Rails.logger.info "ActArchivo guardado: ID #{act_archivo.id}, PDF adjunto: #{act_archivo.pdf.attached?}, tamaño: #{act_archivo.pdf.byte_size}"
      
      act_archivo
    end
  rescue => e
    Rails.logger.error "Error en crear_act_archivo: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    raise
  end

  def enviar_pdf_por_correo(objeto, rprt, dnncnt, act_archivo, filename, context)
    recipient = OpenStruct.new(
      email: dnncnt.email,
      nombre: dnncnt.nombre
    )

    pdf_data = act_archivo.pdf.download

    options = {
      # Se usa rprt
      mailer_action: rprt.to_sym,
      subject: "Información obligatoria para personas denunciantes - Denuncia N° #{objeto.id}",
      act_archivo: act_archivo,
      pdf_data: pdf_data,
      filename: filename
    }

    Mailers::PdfDeliveryService.new(
      context,
      :document,
      objeto,
      recipient,
      options
    ).deliver_now
  end
end