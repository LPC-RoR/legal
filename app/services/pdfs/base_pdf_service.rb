# app/services/pdfs/base_pdf_service.rb
module Pdfs
  class BasePdfService
    attr_reader :reporte, :contexto, :ownr, :objeto_id, :opciones, :datos, :assets

    def initialize(reporte, opciones = {})
      @reporte = reporte.to_s
      @contexto = ClssPdf.context_for(@reporte)
      @ownr = opciones[:ownr]
      @objeto_id = opciones[:objeto_id]
      @opciones = opciones.except(:ownr, :objeto_id)
      @datos = {}
      @assets = {}
    end

    def generar
      cargar_datos!
      cargar_assets!
      html = generar_html!
      pdf_content = generar_pdf!(html)
      almacenar!(pdf_content)
    end

    # ============================================
    # GENERAR MÚLTIPLES PDFs (uno por participante)
    # ============================================
    def self.generar_multiples(reporte, opciones = {})
      servicio = new(reporte, opciones)
      servicio.cargar_datos!
      
      # Obtener participantes del contexto
      participantes = servicio.datos[:denunciantes].to_a + servicio.datos[:denunciados].to_a
      
      resultados = participantes.map do |participante|
        opciones_participante = opciones.merge(
          ownr: participante,           # ← Ownr es el participante
          participante: participante     # ← También pasado para el template
        )
        new(reporte, opciones_participante).generar
      end
      
      resultados
    end

    protected

    def cargar_datos!
      clase_contexto = ClssPdf.context_class(@reporte)
      method_name = "datos_#{@reporte}"
      
      args = [@objeto_id].compact
      args << @opciones if @opciones.present?

      if method_acepta_ownr_keyword?(clase_contexto, method_name)
        @datos = clase_contexto.send(method_name, *args, ownr: @ownr)
      elsif clase_contexto.respond_to?(method_name)
        @datos = clase_contexto.send(method_name, *args)
      elsif clase_contexto.respond_to?(:datos_para)
        @datos = clase_contexto.datos_para(@reporte, @objeto_id, @opciones.merge(ownr: @ownr))
      else
        raise "No se encontró método de datos para reporte: #{@reporte}"
      end

      @datos[:ownr] ||= @ownr
      @datos[:objeto_id] = @objeto_id
    end

    def cargar_assets!
      empresa = @datos[:empresa] || @datos[:objeto]&.try(:ownr)
      @assets = PdfAssetManager.cargar_assets(@reporte, @contexto, empresa)
    end

    def generar_html!
      template = PdfTemplateResolver.resolve(@reporte, @contexto)
      layout = PdfTemplateResolver.layout_for(@reporte, @contexto)

      html = ApplicationController.render(
        template: template,
        layout: layout,
        assigns: preparar_assigns
      )

      html = html.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      
      unless html.include?('<meta charset="UTF-8">')
        html = html.sub(/<head>/i, '<head><meta charset="UTF-8">')
      end

      html
    rescue => e
      Rails.logger.error "[BasePdfService] Error renderizando HTML: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.first(15).join("\n")
      raise
    end

    def generar_pdf!(html)
      PdfFerrumEngine.generate(html, pdf_options)
    end

    def almacenar!(pdf_content, filename = nil)
      validar_pdf!(pdf_content)

      filename ||= "#{@reporte}_#{Time.current.to_i}.pdf"

      # ============================================
      # NOMBRE DEL ACT_ARCHIVO: incluye ID del ownr (participante)
      # ============================================
      nombre = if @ownr.present?
                 "#{@reporte} #{@ownr.id}"
               else
                 "#{@reporte} - #{Time.current.strftime('%d/%m/%Y')}"
               end

      ActArchivo.transaction do
        act_archivo = ActArchivo.new(
          ownr: @ownr,                    # ← Participante como ownr
          act_archivo: @reporte,
          nombre: nombre,
          tipo: 'pdf'
        )

        act_archivo.pdf.attach(
          io: StringIO.new(pdf_content),
          filename: filename,
          content_type: 'application/pdf'
        )

        act_archivo.save!

        if @opciones[:ntfcdr].present? && @reporte != 'dnnc'
          act_archivo.act_referencias.create(ref: @opciones[:ntfcdr], code: @reporte)
        end

        Rails.logger.info "[BasePdfService] ActArchivo guardado: ID #{act_archivo.id}, " \
                          "nombre: #{act_archivo.nombre}, " \
                          "ownr: #{act_archivo.ownr_type}##{act_archivo.ownr_id}, " \
                          "PDF: #{act_archivo.pdf.byte_size} bytes"

        act_archivo
      end
    end

    private

    def resolver_empresa
      empresa = @datos[:empresa] || @datos[:cliente]

      if empresa.nil? && @ownr.present?
        if @ownr.respond_to?(:razon_social)
          empresa = @ownr
        elsif @ownr.respond_to?(:cliente) && @ownr.cliente.present?
          empresa = @ownr.cliente
        end
      end

      empresa ||= @datos[:objeto]&.try(:cliente) || @datos[:objeto]&.try(:ownr)
      empresa
    end

    def empresa_para_logo
      case @contexto
      when :invstgcns
        @datos[:empresa] || @datos[:objeto]&.try(:ownr)
      else
        nil
      end
    end

    def pdf_options
      {
        empresa: resolver_empresa,
        display_header_footer: @opciones.fetch(:display_header_footer, true),
        header_template: @opciones[:header_template],
        footer_template: @opciones[:footer_template],
        header_logo_data_url: PdfFerrumEngine.resolve_header_logo(@contexto, empresa_para_logo)
      }
    end

    def preparar_assigns
      {
        reporte: @reporte,
        contexto: @contexto,
        ownr: @ownr,
        datos: @datos,
        assets: @assets,
        opciones: @opciones,
        txt_editable: @datos[:txt_editable],
        contenido: @datos[:contenido],
        krn_denuncia: @datos[:krn_denuncia],
        participante: @datos[:participante],
        tipo_participante: @datos[:tipo_participante],
        denunciantes: @datos[:denunciantes],
        denunciados: @datos[:denunciados],
        aprobacion: @datos[:aprobacion],
        cliente: @datos[:cliente],
        facturaciones: @datos[:facturaciones],
        total: @datos[:total],
        fecha_aprobacion: @datos[:fecha_aprobacion],
        cantidad_facturaciones: @datos[:cantidad_facturaciones],
        numero_documento: @datos[:numero_documento],
        estado: @datos[:estado],
        observaciones: @datos[:observaciones],
        logo_url: @assets.dig(:images, :logo),
        head_url: @assets.dig(:images, :header) || @assets.dig(:images, :logo),
        sign_url: @assets.dig(:images, :sign),
        empresa: resolver_empresa,
        fecha_generacion: Time.current
      }
    end

    def validar_pdf!(content)
      raise "PDF content es nil" if content.nil?
      raise "PDF content está vacío" if content.empty?
      raise "PDF content no es String" unless content.is_a?(String)
      raise "PDF no válido (no empieza con %PDF)" unless content.start_with?('%PDF')
    end

    def method_acepta_ownr_keyword?(klass, method_name)
      return false unless klass.respond_to?(method_name)
      params = klass.method(method_name).parameters
      params.any? { |type, name| name == :ownr && (type == :key || type == :keyreq) }
    rescue NameError
      false
    end
  end
end