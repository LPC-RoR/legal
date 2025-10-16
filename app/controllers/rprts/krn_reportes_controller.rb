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
    dnnc_id = ClssPdfRprt.rcrd_rprts.include?(params[:rprt]) ? ClssPdfRprt::RCRD_CLSS[params[:rprt].to_sym].find(params[:oid]).dnnc.id : params[:oid]
    @dnnc = KrnDenuncia.estrctr.find(dnnc_id)

    ProcessKrnReportJob.perform_later('generate_and_send', params[:oid], params[:rprt])
    redirect_to ClssPdfRprt.rdrct_path(@dnnc, params[:rprt]),
                notice: 'El reporte se está generando y enviando por correo. Recibirá una notificación cuando finalice.'
  end

  def generate_and_store_dnnc
    dnnc_id = ClssPdfRprt.rcrd_rprts.include?(params[:rprt]) ? ClssPdfRprt::RCRD_CLSS[params[:rprt].to_sym].find(params[:oid]).dnnc.id : params[:oid]
    @dnnc = KrnDenuncia.estrctr.find(dnnc_id)

    ProcessKrnReportJob.perform_later('generate_and_store_dnnc', params[:oid], params[:rprt])
    redirect_to ClssPdfRprt.rdrct_path(@dnnc, params[:rprt]),
                notice: 'El PDF está siendo almacenado, le avisaremos cuando esté listo.'
  end

  def generate_and_store_report
    dnnc_id = ClssPdfRprt.rcrd_rprts.include?(params[:rprt]) ? ClssPdfRprt::RCRD_CLSS[params[:rprt].to_sym].find(params[:oid]).dnnc.id : params[:oid]
    @dnnc = KrnDenuncia.estrctr.find(dnnc_id)

    ProcessKrnReportJob.perform_later('generate_and_store', params[:oid], params[:rprt])
    redirect_to ClssPdfRprt.rdrct_path(@dnnc, params[:rprt]),
                notice: 'Los archivos se están generando en segundo plano.'
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

    def get_grover_pdf_data(ownr, dstntr, oid, rprt, ref, reporte = nil, acts = nil)

      acts ||= ActLoad.for_tree(ownr)   # fallback for controller calls
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
          formats:   [:html],
          locals:    {
            dstntr:  dstntr,
            ownr:    ownr,
            ref:     ref,
            rprt:    rprt,
            reporte: reporte || DenunciaReport.new(ownr).to_h, # fallback por si acaso
            acts: acts          # ← now available in every partial
          }
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
