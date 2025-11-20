# frozen_string_literal: true
class ProcessKrnReportJob < ApplicationJob
  queue_as :pdf          # create a dedicated queue if you wish

  # entry point – decide what to do from the params we receive
  def perform(action, oid, rprt, oclss = nil, current_user_id = nil)
    case action
    when 'generate_and_send'   then generate_and_send_report(oid, rprt)
    when 'generate_and_store_dnnc' then generate_and_store_dnnc(oid, rprt)
    when 'generate_and_store'  then generate_and_store_report(oclss, oid, rprt)
    else
      raise ArgumentError, "Unknown action #{action}"
    end
  end

  private

  # ------------------------------------------------------------------
  # 1)  generate_and_send_report (old controller method)
  # ------------------------------------------------------------------
  def generate_and_send_report(oid, rprt)
    controller = controller_instance
    controller.send(:init_rprt, oid, rprt)

    controller.instance_variable_get(:@dstntrs).each do |dstntr|
      ownr = ClssPdfRprt.dnnc_rprts.include?(rprt) ? controller.instance_variable_get(:@dnnc) : dstntr[:objt]
      pdf_data = controller.send(:get_grover_pdf_data, ownr, dstntr, oid, rprt, controller.instance_variable_get(:@ref), nil, nil)

      # store file
      act_archivo = ownr.act_archivos.new(
        act_archivo: rprt,
        nombre:      ClssPrcdmnt.act_nombre[rprt],
        mdl:         'ClssPrcdmnt',
        skip_pdf_presence: true
      )
      act_archivo.pdf.attach(
        io:       StringIO.new(pdf_data),
        filename: "#{ClssPrcdmnt.act_nombre[rprt]}.pdf",
        content_type: 'application/pdf'
      )
      act_archivo.save!

      # mail
      PdfMailer.send_pdf(
        dstntr[:email],
        pdf_data,
        "#{ClssPrcdmnt.act_nombre[rprt]}.pdf",
        rprt,
        ClssPdfRprt.sbjcts[rprt.to_sym]
      ).deliver_now

      ownr.pdf_registros.create(cdg: rprt, ref: controller.instance_variable_get(:@ref))
    end
  end

  # ------------------------------------------------------------------
  # 2)  generate_and_store_dnnc
  # ------------------------------------------------------------------
  def generate_and_store_dnnc(oid, rprt)
    controller = controller_instance
    controller.send(:init_rprt, oid, rprt)  # ← Esto establecerá @logo_url

    ownr   = controller.instance_variable_get(:@dnnc)
    logo   = controller.instance_variable_get(:@logo_url)
    reporte = DenunciaReport.new(ownr).to_h
    kproc  = KrnPrcdmnt.for(ownr)
    acts   = ActLoad.for_tree(ownr)

    pdf_data = controller.send(:get_grover_pdf_data, ownr, nil, oid, rprt, nil, reporte, acts)

    act_archivo = ownr.act_archivos.new(
      act_archivo: rprt,
      nombre:      ClssPrcdmnt.act_nombre[rprt],
      mdl:         'ClssPrcdmnt'
    )
    act_archivo.pdf.attach(
      io:       StringIO.new(pdf_data),
      filename: "#{ClssPrcdmnt.act_nombre[rprt]}.pdf",
      content_type: 'application/pdf'
    )
    act_archivo.save!
  end

  # ------------------------------------------------------------------
  # 3)  generate_and_store_report
  # ------------------------------------------------------------------
  def generate_and_store_report(oclss, oid, rprt)
    controller = controller_instance
    controller.send(:init_store_rprt, oclss, oid, rprt)


    ownr = controller.instance_variable_get(:@ownr)
    ownr = ownr.ownr if rprt == 'dclrcn'

    dstntr = { objt: ownr, email: ((ownr.dnnc.ownr.demo? and ownr.dnnc.ownr_type == 'Empresa') ? ownr.dnnc.ownr.email_administrador : ownr.email), nombre: ownr.nombre }
    pdf_data = controller.send(:get_grover_pdf_data, ownr, dstntr, oid, rprt, controller.instance_variable_get(:@ref), nil, nil)

    act_archivo = ownr.act_archivos.new(
      act_archivo: rprt,
      nombre:      ClssPrcdmnt.act_nombre[rprt],
      mdl:         'ClssPrcdmnt',
      skip_pdf_presence: true
    )
    act_archivo.pdf.attach(
      io:       StringIO.new(pdf_data),
      filename: "#{ClssPrcdmnt.act_nombre[rprt]}.pdf",
      content_type: 'application/pdf'
    )
    act_archivo.save!

    ownr.pdf_registros.create(cdg: rprt, ref: controller.instance_variable_get(:@ref))

  end

  # helper – build a *throw-away* controller instance so we can re-use
  # the private methods without copy-pasting them.
  def controller_instance
    Rprts::KrnReportesController.new.tap do |ctrl|
      # mimic request env so url_helpers & Grover work
      ctrl.request = ActionDispatch::Request.new({})
      ctrl.request.env['HTTP_HOST'] = '127.0.0.1:3000'
      ctrl.request.env['REQUEST_METHOD'] = 'GET'
      ctrl.request.env['rack.url_scheme'] = 'http'
    end
  end
end