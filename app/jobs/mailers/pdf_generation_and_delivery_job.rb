# app/jobs/mailers/pdf_generation_and_delivery_job.rb
class Mailers::PdfGenerationAndDeliveryJob < ApplicationJob
  queue_as :pdf_generation

  FERRUM_TIMEOUT = 60  # segundos para operaciones del navegador
  PAGE_TIMEOUT = 45    # segundos para carga de página
  PDF_TIMEOUT = 45     # segundos para generación de PDF

  def perform(denuncia_id, rprt, nid)

    browser = nil
    logo_path = nil
    sign_path = nil

    begin

      browser_path = setup_chromium_environment!
    
      browser = Ferrum::Browser.new(
        headless: true,
        browser_path: browser_path,
        timeout: FERRUM_TIMEOUT,  # ← TIMEOUT GLOBAL DEL NAVEGADOR
        window_size: [1280, 1024],
        args: [
          "--no-sandbox",
          "--disable-dev-shm-usage",
          "--disable-gpu",
          "--disable-software-rasterizer",
          "--disable-extensions",
          "--disable-background-networking",
          "--disable-sync",
          "--disable-translate",
          "--disable-default-apps",
          "--mute-audio",
          "--no-first-run",
          "--memory-pressure-off",
          "--max_old_space_size=4096"
        ]
      )
    
      denuncia = KrnDenuncia.find(denuncia_id)
      return unless denuncia

      Rails.logger.info "Job en curso: #{rprt}"

      clss = ClssPdfRprt::RCRD_CLSS[rprt.to_sym]
      ntfcdr = if nid.present? && clss.respond_to?(:find)
                 clss.find(nid)
               else
                 Rails.logger.warn "PDF report '#{rprt}' no soportado o nid inválido"
                 nil
               end


      context = :investigations
      
      set_active_storage_url_options!

      logo_path = obtener_ruta_imagen_logo(denuncia)
      sign_path = obtener_ruta_imagen_sign(denuncia)
      
      head_path = logo_path || Rails.root.join('public', 'mssgs', 'email_head.png').to_s
      sign_path_final = sign_path || Rails.root.join('public', 'mssgs', 'email_sign.png').to_s


      # PROCESAR PARTICIPANTES CON PROTECCIÓN ANTI-DUPLICADOS
      # REPORTES DEL DENUNCIANTE
      if ClssPdfRprt.dnncnt_rprt?(rprt)
        denuncia.krn_denunciantes.each do |dnncnt|
          process_participante(denuncia, rprt, dnncnt, context, head_path, sign_path_final, ntfcdr, browser)
        end
      end

      # REPORTES DEL DENUNCIADO
      if ClssPdfRprt.dnncd_rprt?(rprt)
        denuncia.krn_denunciados.each do |dnncd|
          process_participante(denuncia, rprt, dnncd, context, head_path, sign_path_final, ntfcdr, browser)
        end
      end

      # REPORTES DEL TESTIGO
      if ClssPdfRprt.tstg_rprt?(rprt)
        denuncia.krn_testigos.each do |tstg|
          process_participante(denuncia, rprt, tstg, context, head_path, sign_path_final, ntfcdr, browser)
        end
      end

      # ['dclrcn', 'txt_dclrcn']
      if ClssPdfRprt.ownr_rprt?(rprt)
        dstntr = ClssPdfRprt.no_email_rprt?(rprt) ? nil : ntfcdr.ownr
        process_participante(denuncia, rprt, dstntr, context, head_path, sign_path_final, ntfcdr, browser)
      end

      # ['crdncn_apt', 'infrmcn']
      if ClssPdfRprt.cntct_rprt?(rprt)
        grupo = 'Apt' if rprt == 'crdncn_apt'
        grupo = 'RRHH' if rprt == 'infrmcn'
        dstntrs = AppContacto.where(grupo: grupo)

        dstntrs.each do |dstntr|
          process_participante(denuncia, rprt, dstntr, context, head_path, sign_path_final, denuncia, browser)
        end
      end

      # ['dnnc', 'st_dclrcns']
      if ClssPdfRprt.rcrs_rprt?(rprt)
        Rails.logger.info "Entro en rcrs_rprt, reporte: #{rprt}"
        process_participante(denuncia, rprt, nil, context, head_path, sign_path_final, denuncia, browser)
      end

      # ['txt_infrm', 'texto_anonimizado', 'resumen_cronologico']
      if ClssPdfRprt.txt_rcrs_rprt?(rprt)
        Rails.logger.info "Entro en txt_rcrs_rprt, reporte: #{rprt}"
        process_participante(denuncia, rprt, nil, context, head_path, sign_path_final, ntfcdr, browser)
      end

    ensure
      limpiar_temporales(logo_path) if logo_path.present?
      limpiar_temporales(sign_path) if sign_path.present?
      browser&.quit
    end
    
  rescue => e
    Rails.logger.error "Error fatal en PDF job: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n")
    # NO relanzamos el error para evitar reintentos automáticos que reenvíen emails
    # En su lugar, notificar a administradores o sistema de monitoreo
    # raise  <- COMENTADO INTENCIONALMENTE
  end

  def setup_chromium_environment!
    browser_path = detect_browser_path
    Rails.logger.info "Browser path: #{browser_path}"
    
    ENV['LANG'] ||= 'es_CL.UTF-8'
    ENV['LC_ALL'] ||= 'es_CL.UTF-8'
    
    browser_path
  end

  private

  def detect_browser_path
    candidates = [
      '/usr/bin/google-chrome-stable',
      '/usr/bin/google-chrome',
      '/usr/bin/chromium-browser',
      '/usr/bin/chromium',
      '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe'
    ]
    
    candidates.find { |path| File.exist?(path) } || 
      raise("No se encontró Chrome/Chromium. Instala con: sudo apt install google-chrome-stable")
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

  def process_participante(denuncia, rprt, prtcpnt, context, head_path, sign_path, ntfcdr, browser)
    # CLAVE: Verificar si ya se envió este reporte a este participante recientemente
    # Esto previene reenvíos incluso si el job se reintenta
    prtcpnt_id = prtcpnt&.id || 'sin_prtcpt'

    # LOCK DISTRIBUIDO POR PARTICIPANTE (solo si el reporte no está exento)
    lock_key = "pdf_generation:#{denuncia.id}:#{rprt}:#{prtcpnt_id}:#{Date.current}"

    unless ClssPdfRprt.no_lock?(rprt)
      unless Rails.cache.write(lock_key, true, expires_in: 30.minutes, unless_exist: true)
        Rails.logger.warn "Job bloqueado - ya en ejecución para participante: #{lock_key}"
        return
      end
    end

    # DEDUPLICACIÓN DIARIA (solo si el reporte no está exento)
    cache_key = "pdf_enviado:#{denuncia.id}:#{rprt}:#{prtcpnt_id}:#{Date.current}"
    
    if !ClssPdfRprt.no_lock?(rprt) && Rails.cache.exist?(cache_key)
      Rails.logger.info "PDF ya enviado hoy para #{cache_key}, saltando..."
      Rails.cache.delete(lock_key) if defined?(lock_key) && lock_key.present? # Liberar lock inmediatamente
      return
    end

    # A partir de este punto en process_participante rprt y ntfcdr puede cambiar para cubrir txt_rcrs_rprt
    if ClssPdfRprt.txt_rcrs_rprt?(rprt)
      pdf_ntfcdr  = ntfcdr.ownr
      pdf_rprt    = ClssPdfRprt.pdf_rprt(pdf_ntfcdr, rprt)
      krn_kywrd = pdf_ntfcdr.kywrd[:krn]
      filename = "#{rprt}_#{krn_kywrd}_#{Time.current.to_i}.pdf"
    else
      pdf_ntfcdr  = ntfcdr
      pdf_rprt    = rprt
      krn_kywrd = prtcpnt ? prtcpnt.kywrd[:krn] : "dnnc_#{denuncia.id}"
      filename = "#{pdf_rprt}_#{krn_kywrd}_#{Time.current.to_i}.pdf"
    end


    unless ClssPdfRprt.adjunto_subido?(rprt)
      html = generar_html_pdf(denuncia, pdf_rprt, prtcpnt, context, head_path, sign_path, krn_kywrd, ntfcdr)
      Rails.logger.info "HTML generado, longitud: #{html.length} caracteres"
      
      pdf_content = generar_pdf_con_ferrum(html, denuncia, browser)
      
      Rails.logger.info "PDF generado, longitud: #{pdf_content&.length || 'NIL'} bytes"
      Rails.logger.info "Es PDF válido? #{pdf_content&.start_with?('%PDF')}"
    end
    
    if ClssPdfRprt.adjunto_subido?(rprt)
      act_archivo = referenciar_act_archivo_dnnc(denuncia, prtcpnt, rprt, ntfcdr)
    else
      if ClssPdfRprt.txt_rcrs_rprt?(rprt)
        ownr = pdf_ntfcdr
      else
        ownr = prtcpnt.nil? ? denuncia : prtcpnt
      end
      # Si es txt_rcrs_rprt? el notificador debe seguir siendo KrnTexto
      # Ya se corrigió el ownr y el nombre del reporte
      act_archivo = crear_act_archivo(ownr, pdf_rprt, pdf_content, filename, ntfcdr)
    end

    unless act_archivo
      Rails.logger.error "No se pudo obtener o crear act_archivo, rprt : #{pdf_rprt}"
      return
    end
    
    optn_email = prtcpnt&.tiene_email_validado? || prtcpnt&.tiene_email_verificado?
    optn_certf = ClssPdfRprt.cntct_rprt?(rprt) ? false : prtcpnt&.articulo_516?

    if !optn_certf && optn_email && !ClssPdfRprt.no_email_rprt?(rprt)
      enviar_pdf_por_correo(denuncia, rprt, prtcpnt, act_archivo, filename, context)
      
      # MARCAR COMO ENVIADO EN CACHE (24 horas) — solo si el reporte no está exento
      Rails.cache.write(cache_key, true, expires_in: 24.hours) unless ClssPdfRprt.no_lock?(rprt)
    end
  rescue => e
    Rails.logger.error "Error procesando participante #{prtcpnt&.id}: #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n")
    raise  # Relanzar para que falle el job pero sin reenviar a otros que ya se 
  ensure
    Rails.cache.delete(lock_key) if defined?(lock_key) && lock_key.present? && !ClssPdfRprt.no_lock?(rprt)
  end

  def limpiar_temporales(path)
    return if path.blank?
    return if path.to_s.start_with?(Rails.root.join('public').to_s)
    
    File.delete(path) if File.exist?(path)
  rescue => e
    Rails.logger.error "Error eliminando temporal #{path}: #{e.message}"
  end

  def generar_html_pdf(objeto, rprt, prtcpnt, context, head_path, sign_path, krn_kywrd, ntfcdr)
    if prtcpnt
      recipient = OpenStruct.new(
        email: prtcpnt.email,
        nombre: prtcpnt.nombre
      )
    else
      recipient = nil
    end

    @reporte  = rprt == 'dnnc' ? DenunciaReport.new(objeto).to_h : nil

    branding = objeto.ownr&.tenant&.branding_for(context)
    
    head_url = imagen_a_data_url(head_path)
    sign_url = imagen_a_data_url(sign_path)

    html = ApplicationController.render(
      template: "mailers/contexts/investigations/document/#{rprt}_pdf",
      layout: 'mailers/pdf/base',
      assigns: {
        record: objeto,
        prtcpnt: prtcpnt,
        ntfcdr: ntfcdr,
        recipient: recipient,
        branding: branding,
        reporte: @reporte,
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

  def generar_pdf_con_ferrum(html, objeto, browser)
    page = browser.create_page
    
    # ← TIMEOUT PARA OPERACIONES DE PÁGINA
    page.timeout = PAGE_TIMEOUT
    
    # ============================================================
    # CAMBIO: Usar archivo temporal en lugar de data URI
    # Esto evita que Addressable::URI.parse procese 121KB+ en una regex
    # ============================================================
    require 'tempfile'
    
    tempfile = Tempfile.new(['pdf_reporte', '.html'])
    tempfile.write(html)
    tempfile.flush  # Asegurar que se escriba en disco
    
    file_url = "file://#{tempfile.path}"
    
    Rails.logger.info "Cargando página via archivo temporal: #{tempfile.path}, HTML size: #{html.length} chars"
    
    page.go_to(file_url)
    # ============================================================
    
    # Esperar a que el DOM esté listo y las fuentes carguen
    # ← TIMEOUT PARA ESPERA DE RED INACTIVA
    page.network.wait_for_idle(timeout: PAGE_TIMEOUT)
    
    # Esperar adicionalmente por fuentes web y renderizado
    sleep 1.5
    
    empresa = objeto&.ownr
    razon_social = empresa&.razon_social || "Empresa"
    fecha = I18n.l(Time.current, format: :long)

    footer_template = <<-HTML
      <div style="font-size: 8pt; font-family: 'Open Sans', sans-serif; 
                  width: 100%; padding: 0 15mm; margin-bottom: 10mm;">
        <span style="color: #adb5bd;">#{razon_social}</span>
        <span style="color: #adb5bd; float: right; font-size: 7pt;">#{fecha}</span>
      </div>
    HTML

    Rails.logger.info "Generando PDF con timeout: #{PDF_TIMEOUT}s"
    
    # ← TIMEOUT PARA GENERACIÓN DE PDF
    pdf_data = page.pdf(
      paper_width: 8.5,
      paper_height: 11.0,
      margin_top: 0.39,
      margin_bottom: 0.98,
      margin_left: 0.39,
      margin_right: 0.39,
      print_background: true,
      display_header_footer: true,
      header_template: ' ',
      footer_template: footer_template,
      encoding: :binary,
      timeout: PDF_TIMEOUT  # ← EXPLÍCITO PARA PDF
    )
    
    pdf_data = pdf_data.force_encoding('ASCII-8BIT')
    
    Rails.logger.info "PDF generado, longitud: #{pdf_data.length} bytes"
    Rails.logger.info "Es PDF válido? #{pdf_data.start_with?('%PDF')}"
    
    pdf_data
    
  rescue => e
    Rails.logger.error "Error en Ferrum PDF: #{e.class} - #{e.message}"
    Rails.logger.error "HTML length: #{html.length}"
    raise
  ensure
    page&.close
    # ============================================================
    # LIMPIEZA: Eliminar archivo temporal
    # ============================================================
    if defined?(tempfile) && tempfile.respond_to?(:close)
      tempfile.close
      tempfile.unlink
    end
    # ============================================================
  end

  def footer_template_para(objeto)
    empresa = objeto&.ownr
    razon_social = empresa&.razon_social || "Empresa"
    fecha = I18n.l(Time.current, format: :long)

    <<-HTML
      <div style="font-size: 8pt; font-family: 'Open Sans', sans-serif; 
                  width: 100%; padding: 0 15mm; margin-bottom: 10mm;
                  display: flex; justify-content: space-between; align-items: center;">
        <span style="color: #adb5bd;">#{razon_social}</span>
        <span style="color: #adb5bd; font-size: 7pt;">#{fecha}</span>
      </div>
    HTML
  end

  def referenciar_act_archivo_dnnc(denuncia, prtcpnt, rprt, ntfcdr)
    if ClssPdfRprt.act_dnnc?[rprt.to_sym]
      ntfcdr.act_referencias.create(ref: prtcpnt, code: rprt)
    end
    
    unless ntfcdr
      Rails.logger.error "Referenciar #{prtcpnt.id}, rprt #{rprt} #{ClssPdfRprt.act_dnnc?[rprt.to_sym]}"
      return
    end

    ntfcdr
  end

  def crear_act_archivo(ownr, rprt, pdf_content, filename, ntfcdr)
    raise "PDF content es nil" if pdf_content.nil?
    raise "PDF content está vacío" if pdf_content.empty?
    raise "PDF content no es String" unless pdf_content.is_a?(String)
    raise "PDF no válido (no empieza con %PDF)" unless pdf_content.start_with?('%PDF')

    ActArchivo.transaction do
      dnnc_id = (ClssPdfRprt.cntct_rprt?(rprt) || ClssPdfRprt.rcrs_rprt?(rprt) || ClssPdfRprt.txt_rcrs_rprt?(rprt)) ? ntfcdr&.id : ownr.dnnc&.id

      act_archivo = ActArchivo.new(
        ownr: ownr,
        act_archivo: rprt,
        nombre: "#{rprt} - Denuncia #{dnnc_id}",
        tipo: 'pdf',
      )

      act_archivo.pdf.attach(
        io: StringIO.new(pdf_content),
        filename: filename,
        content_type: 'application/pdf'
      )

      act_archivo.save!

      act_archivo.act_referencias.create(ref: ntfcdr, code: rprt) if ntfcdr && rprt != 'dnnc'
      
      Rails.logger.info "ActArchivo guardado: ID #{act_archivo.id}, PDF adjunto: #{act_archivo.pdf.attached?}, tamaño: #{act_archivo.pdf.byte_size}"
      
      act_archivo
    end
  rescue => e
    Rails.logger.error "Error en crear_act_archivo: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    raise
  end

  def enviar_pdf_por_correo(objeto, rprt, prtcpnt, act_archivo, filename, context)
    # IDEMPOTENCIA: Verificar en base de datos si ya fue enviado
    if act_archivo.sndd?
      Rails.logger.info "Email ya enviado para act_archivo #{act_archivo.id}, saltando..."
      return
    end

    recipient = OpenStruct.new(
      email: prtcpnt.email,
      nombre: prtcpnt.nombre
    )

    pdf_data = act_archivo.pdf.download

    options = {
      mailer_action: rprt.to_sym,
      subject: "#{ClssPdfRprt.sbjcts[rprt.to_sym]} - Denuncia N° #{objeto.id}",
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

    # Marcar como enviado
    act_archivo.update!(sndd: true)
  end

end