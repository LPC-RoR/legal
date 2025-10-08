class Rprts::KrnReportesController < ApplicationController

  include Karin

  layout :pdf

  include Karin

  def init_rprt(oid, rprt)
    dnnc_id = ClssPdfRprt.rcrd_rprts.include?(rprt) ? ClssPdfRprt::RCRD_CLSS[rprt.to_sym].find(oid).dnnc.id : oid
    @dnnc = KrnDenuncia.estrctr.find(dnnc_id)
    @logo_url = @dnnc.ownr.logo_url
    @ref = ClssPdfRprt.rcrd_rprts.include?(rprt) ? ClssPdfRprt::RCRD_CLSS[rprt.to_sym].find(oid) : nil
    @dstntrs = rprt == 'dclrcn' ? @ref.destinatario : (ClssPdfRprt.dnnc_rprts.include?(rprt) ? @dnnc.ownr.destinatarios(rprt) : @dnnc.destinatarios(rprt))
  end

  def dnncnt_info_oblgtr
    respond_to_pdf('dnncnt_info_oblgtr')
  end

  def comprobante
    respond_to_pdf('comprobante')
  end

  def dnnc
    respond_to_pdf('dnnc')
  end

  def drchs
    respond_to_pdf('drchs')
  end

  def infrmcn
    respond_to_pdf('infrmcn')
  end

  def crdncn_apt
    respond_to_pdf('crdncn_apt')
  end

  def invstgcn
    respond_to_pdf('invstgcn')
  end

  def medidas_resguardo
    respond_to_pdf('medidas_resguardo')
  end

  def invstgdr
    respond_to_pdf('invstgdr')
  end

  def dclrcn
    respond_to_pdf('dclrcn')
  end

  def drvcn
    respond_to_pdf('drvcn')
  end

  # Método para generar PDF y enviarlo por correo electrónico
  def generate_and_send_report

    init_rprt(params[:oid], params[:rprt])
    
    @dstntrs.each do |dstntr|

      @ownr = ClssPdfRprt.dnnc_rprts.include?(params[:rprt]) ? @dnnc : dstntr[:objt]

      pdf_data = get_grover_pdf_data(@ownr, dstntr, params[:oid], params[:rprt], @ref)

      # Guardar en ActArchivo
      act_archivo = @ownr.act_archivos.new(
        act_archivo: params[:rprt],
        nombre: ClssPrcdmnt.act_nombre[params[:rprt]],
        mdl: 'ClssPrcdmnt',
        skip_pdf_presence: true        # <-- bypass validation
      )
      act_archivo.pdf.attach(
        io: StringIO.new(pdf_data),
        filename: "#{ClssPrcdmnt.act_nombre[params[:rprt]]}.pdf",
        content_type: 'application/pdf'
      )
      act_archivo.save!

      # Enviar por correo
      PdfMailer.send_pdf(
        dstntr[:email], 
        pdf_data, 
        "#{ClssPrcdmnt.act_nombre[params[:rprt]]}.pdf",
        params[:rprt],
        ClssPdfRprt.sbjcts[params[:rprt].to_sym]
      ).deliver_now

      @ownr.pdf_registros.create(cdg: params[:rprt])
    end
    
    ntc = @dstntrs.length == 0 ? 'No se encontraron destinatarios pendientes.' : "El reporte ha sido enviado exitosamente a #{@dstntrs.length} participante(s)."
    redirect_to ClssPdfRprt.rdrct_path(@dnnc, params[:rprt]), notice: ntc
  end

  def generate_and_store_dnnc
    @ownr = KrnDenuncia.estrctr.find(params[:oid])
    @logo_url = @ownr.dnnc.ownr.logo_url
    @rprt = DenunciaReport.new(@ownr).to_h
    @kproc = KrnPrcdmnt.for(@ownr)
    @acts_hsh = ActLoad.for_tree(@ownr)

    pdf_data = get_grover_pdf_data(@ownr, nil, params[:oid], params[:rprt], nil)

    # Guardar en ActArchivo
    act_archivo = @ownr.act_archivos.new(
      act_archivo: params[:rprt],
      nombre: ClssPrcdmnt.act_nombre[params[:rprt]],
      mdl: 'ClssPrcdmnt',
    )
    act_archivo.pdf.attach(
      io: StringIO.new(pdf_data),
      filename: "#{ClssPrcdmnt.act_nombre[params[:rprt]]}.pdf",
      content_type: 'application/pdf'
    )
    act_archivo.save!

    redirect_to ClssPdfRprt.rdrct_path(@ownr, params[:rprt])
  end

  def generate_and_store_report
    init_rprt(params[:oid], params[:rprt])
    
    @dstntrs.each do |dstntr|

      @ownr = ClssPdfRprt.dnnc_rprts.include?(params[:rprt]) ? @dnnc : dstntr[:objt]

      pdf_data = get_grover_pdf_data(@ownr, dstntr, params[:oid], params[:rprt], @ref)

      # Guardar en ActArchivo
      act_archivo = @ownr.act_archivos.new(
        act_archivo: params[:rprt],
        nombre: ClssPrcdmnt.act_nombre[params[:rprt]],
        mdl: 'ClssPrcdmnt',
        skip_pdf_presence: true        # <-- bypass validation
      )
      act_archivo.pdf.attach(
        io: StringIO.new(pdf_data),
        filename: "#{ClssPrcdmnt.act_nombre[params[:rprt]]}.pdf",
        content_type: 'application/pdf'
      )
      act_archivo.save!

      @ownr.pdf_registros.create(cdg: params[:rprt])
    end
    
    redirect_to ClssPdfRprt.rdrct_path(@dnnc, params[:rprt]), notice: ntc
  end

  private

    def respond_to_pdf(rprt)
      respond_to do |format|
        format.pdf do
          render pdf: "documento",
            margin: { top: '.5cm', bottom: '1cm', left: '1cm', right: '1cm' },
            page_size: 'A4',
            disable_smart_shrinking: true, # Importante para respetar dimensiones
            encoding: 'UTF-8',
            template: "rprts/krn_reportes/#{rprt}",
            layout: 'pdf',
            show_as_html: params[:debug].present?,
            footer: { center: "Página [page] de [topage]", encoding: 'UTF-8' }
        end
      end
    end

    def get_grover_pdf_data(ownr, dstntr, oid, rprt, ref)
      if ClssPdfRprt.attch_rprt.include?(rprt)
        # Attachar archivo existente
        # act_archivo: 'mdds_rsgrd', es así porque es distinto a rprt
          pdf_blob = ownr.dnnc
                         &.act_archivos
                         &.find_by(act_archivo: 'mdds_rsgrd')
                         &.pdf
                         &.blob
          pdf_blob&.download
      else
        # Crear documento
        html = render_to_string(
          template: "rprts/krn_reportes/#{rprt}",
          layout:    'pdf',
          formats:   [:html],        # importante: no :pdf
          locals:    { dstntr: dstntr, ownr: ownr, ref: ref }
        )

        return Grover.new(html,
           format: 'A4',
           print_background: true,
           display_url: Rails.application.routes.url_helpers.root_url(host: 'http://127.0.0.1:3000'),
           wait_until: 'domcontentloaded',
           timeout: 8_000,
           launch_args: ['--no-sandbox',
                         '--disable-setuid-sandbox',
                         '--disable-dev-shm-usage',
                         '--disable-web-security',
                         '--disable-background-timer-throttling',
                         '--disable-renderer-backgrounding',
                         '--disable-backgrounding-occluded-windows',
                         '--disable-features=TranslateUI',
                         '--disable-ipc-flooding-protection',
                         '--disable-features=VizDisplayCompositor']).to_pdf
      end
    end

end
