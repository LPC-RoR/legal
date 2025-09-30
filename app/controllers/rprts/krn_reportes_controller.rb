class Rprts::KrnReportesController < ApplicationController

  REF_CLSS = {
    'invstgdr'  => KrnInvDenuncia,
    'drvcn'     => KrnDerivacion,
    'dclrcn'    => KrnDeclaracion,
    'infrmcn'   => AppContacto,
    'crdncn_apt'=> AppContacto
  }.freeze

  include Karin

  layout :pdf

  include Karin
  include ProcControl

  def load_data(oid, rprt)
    case rprt
    when 'invstgdr'
      @objeto = KrnInvDenuncia.find(oid)
      dnnc = @objeto.krn_denuncia
    when 'drvcn'
      @objeto = KrnDerivacion.find(oid)
      dnnc = @objeto.krn_denuncia
    when 'dclrcn'
      @objeto = KrnDeclaracion.find(oid)
      dnnc = @objeto.ownr.dnnc
    else
      @objeto = KrnDenuncia.find(oid)
      dnnc = @objeto
    end
    @logo_url = @objeto.dnnc.ownr.logo_url
    load_objt(dnnc)
    load_proc(dnnc)
  end

  def dnncnt_info_oblgtr
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.dnnc.ownr.logo_url

    respond_to_pdf('dnncnt_info_oblgtr')
  end

  def comprobante
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.dnnc.ownr.logo_url

    respond_to_pdf('comprobante')
  end

  def dnnc
    respond_to_pdf('dnnc')
  end

  def drchs
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.ownr.logo_url

    respond_to_pdf('drchs')
  end

  def infrmcn
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.ownr.logo_url

    load_objt(@objeto)

    set_tabla('krn_denunciantes', @objeto.krn_denunciantes.rut_ordr, false)
    set_tabla('krn_denunciados', @objeto.krn_denunciados.rut_ordr, false)

    respond_to_pdf('infrmcn')
  end

  def crdncn_apt
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.ownr.logo_url

    load_objt(@objeto)

    set_tabla('krn_denunciantes', @objeto.krn_denunciantes.rut_ordr, false)

    respond_to_pdf('crdncn_apt')
  end

  def invstgcn
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.ownr.logo_url

    respond_to_pdf('invstgcn')
  end

  def medidas_resguardo
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.ownr.logo_url

    respond_to_pdf('medidas_resguardo')
  end

  def invstgdr
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.ownr.logo_url

    respond_to_pdf('invstgdr')
  end

  def dclrcn
    @objeto = KrnDeclaracion.find(params[:oid])
    @logo_url = @objeto.ownr.logo_url

    respond_to_pdf('dclrcn')
  end

  def drvcn
    @objeto = KrnDenuncia.find(params[:oid])
    @logo_url = @objeto.ownr.logo_url

    respond_to_pdf('drvcn')
  end

  def sbjcts
    {
      infrmcn:    'Verificación de datos y solicitud de documentación.',
      crdncn_apt: 'Coordinación de atención psicológica temprana.',
      drvcn:      'Notificación de derivación de la denuncia.',
      invstgcn:   'Notificación de recepción de denuncia.',
      invstgdr:   'Notificación de asignación de Investigador.',
      dclrcn:     'Citación a declarar.'
    }.freeze
  end

  # Método para generar PDF y enviarlo por correo electrónico
  def generate_and_send_report

    # Manejo de tablas
    load_data(params[:oid], params[:rprt])
    dstntrs = get_dstntrs(params[:oid], params[:rprt])

    dstntrs.each do |dstntr|
      ownr_fl  = ['infrmcn', 'crdncn_apt'].include?(params[:rprt]) ? KrnDenuncia.find(params[:oid]) : dstntr[:objt]
      ref_type = ['infrmcn', 'crdncn_apt', 'drvcn', 'invstgdr', 'dclrcn'].include?(params[:rprt]) ? REF_CLSS[params[:rprt]].to_s : nil
      ref_id   = ['drvcn', 'invstgdr', 'dclrcn'].include?(params[:rprt]) ? params[:oid] : (['infrmcn', 'crdncn_apt'].include?(params[:rprt]) ? dstntr[:objt].id : nil)

      # Generación de la DATA
      case params[:rprt]
      when 'medidas_resguardo'
          pdf_blob = ownr_fl.dnnc
                         &.act_archivos
                         &.find_by(act_archivo: 'mdds_rsgrd')
                         &.pdf
                         &.blob
          pdf_data = pdf_blob&.download

          unless pdf_data.present?
            Rails.logger.warn "No se encontró PDF de medidas_resguardo para oid=#{params[:oid]}"
            next  # <-- saltar este destinatario y continuar con el siguiente
          end
        else
          pdf_data = get_pdf_data(dstntr, params[:oid], params[:rprt])
      end

      # Guardar en ActArchivo
      act_archivo = dstntr[:objt].act_archivos.new(
        act_archivo: params[:rprt],
        nombre: ClssPrcdmnt.act_nombre[params[:rprt]],
        mdl: 'ClssPrcdmnt',
        skip_pdf_presence: true        # <-- bypass validation
      )
      act_archivo.pdf.attach(
        io: StringIO.new(pdf_data),
        filename: "rep_#{ClssPrcdmnt.act_nombre[params[:rprt]]}.pdf",
        content_type: 'application/pdf'
      )
      act_archivo.save!

      # Enviar por correo
      PdfMailer.send_pdf(
        dstntr[:email], 
        pdf_data, 
        "rep_#{params[:rprt]}.pdf",
        params[:rprt],
        sbjcts[params[:rprt].to_sym]
      ).deliver_now

      ownr_fl.pdf_registros.create(ref_type: ref_type, ref_id: ref_id, cdg: params[:rprt])
    end
    
    set_bck_rdrccn
    ntc = dstntrs.length == 0 ? 'No se encontraron destinatarios pendientes.' : "El reporte ha sido enviado exitosamente a #{dstntrs.length} participante(s)."
    redirect_to @bck_rdrccn, notice: ntc
  end

  def generate_and_store_dnnc
    @ownr = KrnDenuncia.estrctr.find(params[:oid])
    @logo_url = @ownr.dnnc.ownr.logo_url
    @rprt = DenunciaReport.new(@ownr).to_h
    @krn_proc = KrnPrcdmnt.for(@ownr)
    @acts_hsh = ActLoad.for_tree(@ownr)

    pdf_data = get_pdf_data(nil, params[:oid], params[:rprt])

    # Guardar en ActArchivo
    act_archivo = @ownr.act_archivos.new(
      act_archivo: params[:rprt],
      nombre: ClssPrcdmnt.act_nombre[params[:rprt]],
      mdl: 'ClssPrcdmnt',
    )
    act_archivo.pdf.attach(
      io: StringIO.new(pdf_data),
      filename: "rep_#{ClssPrcdmnt.act_nombre[params[:rprt]]}.pdf",
      content_type: 'application/pdf'
    )
    act_archivo.save!

    redirect_to "/krn_denuncias/#{@ownr.id}_2"
  end

  def generate_and_store_report
    @ownr = KrnDenuncia.find(params[:oid]) if ['infrmcn', 'crdncn_apt', 'medidas_resguardo'].include?(params[:rprt])

    load_data(params[:oid], params[:rprt])
    dstntrs = get_dstntrs(params[:oid], params[:rprt])

    dstntrs.each do |dstntr|

      # Generación de la DATA
      case params[:rprt]
      when 'medidas_resguardo'
        pdf_rcrd = ownr_fl.dnnc&.act_archivos
                 .find_by(act_archivo: 'medidas_resguardo')
                 &.pdf
                 &.blob
        pdf_data = pdf_rcrd&.download
      else
        pdf_data = get_pdf_data(dstntr, params[:oid], params[:rprt])

        # Guardar en ActArchivo
        act_archivo = dstntr[:objt].act_archivos.new(
          act_archivo: params[:rprt],
          nombre: ClssPrcdmnt.act_nombre[params[:rprt]],
          mdl: 'ClssPrcdmnt',
        )
        act_archivo.pdf.attach(
          io: StringIO.new(pdf_data),
          filename: "rep_#{ClssPrcdmnt.act_nombre[params[:rprt]]}.pdf",
          content_type: 'application/pdf'
        )
        act_archivo.save!

      end

      if dstntr[:ref].present?
        ref_type = dstntr[:ref].class.name
        ref_id   = dstntr[:ref].id
      else
        ref_type = nil
        ref_id   = nil
      end

      dstntr[:objt].pdf_registros.create(ref_type: ref_type, ref_id: ref_id, cdg: params[:rprt])
    end
    
    set_bck_rdrccn
    ntc = dstntrs.length == 0 ? 'No se encontraron destinatarios pendientes.' : "El reporte ha sido enviado exitosamente a #{dstntrs.length} participante(s)."
    redirect_to @bck_rdrccn, notice: ntc
  end

  def audit_rprt
    @pdf_archivo = PdfArchivo.find_by(codigo: params[:rprt])
    load_data(params[:oid], params[:rprt])
    dstntrs = get_dstntrs(params[:oid], params[:rprt])

    dstntrs.each do |dstntr|
      if dstntr[:ref].present?
        ref_type = dstntr[:ref].class.name
        ref_id   = dstntr[:ref].id
      else
        ref_type = nil
        ref_id   = nil
      end

      dstntr[:objt].pdf_registros.create(pdf_archivo_id: @pdf_archivo.id, ref_type: ref_type, ref_id: ref_id, audtd: true, cdg: params[:rprt])
    end
    set_bck_rdrccn
    ntc = dstntrs.length == 0 ? 'No se encontraron destinatarios pendientes.' : "El reporte ha sido enviado exitosamente a #{dstntrs.length} participante(s)."
    redirect_to @bck_rdrccn, notice: ntc
  end

  private

    def get_rdrccn
      case @objeto.class.name
      when 'KrnDeclaracion'
        dnnc_id = "#{@objeto.ownr.dnnc.id}_1"
      when 'KrnInvDenuncia'
        dnnc_id = "#{@objeto.krn_denuncia_id}_0"
      when 'KrnDerivacion'
        dnnc_id = "#{@objeto.krn_denuncia_id}_0"
      else
        dnnc_id = "#{@objeto.id}_2"
      end
      @rdrccn = "/krn_denuncias/#{dnnc_id}"
    end

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

    def get_objt(oid, rprt)
      if ['dnncnt_info_oblgtr', 'comprobante', 'infrmcn', 'crdncn_apt', 'medidas_resguardo'].include?(rprt)
          KrnDenuncia.find(oid)
      else
        case rprt
        when 'drvcn'
          KrnDerivacion.find(oid)
        when 'invstgcn'
          nil
        when 'invstgdr'
          KrnInvDenuncia.find(oid)
        end
      end
    end

    def get_invstgdr(oid, rprt)
      case rprt
      when 'drvcn'
        invstgdr = KrnDerivacion.find(oid).krn_denuncia.krn_investigadores.last
      when 'dnncnt_info_oblgtr'
        invstgdr = KrnDenuncia.find(oid).krn_investigadores.last
      when 'comprobante'
        invstgdr = KrnDenuncia.find(oid).krn_investigadores.last
      when 'invstgcn'
        invstgdr = KrnDenuncia.find(oid).krn_investigadores.last
      when 'invstgdr'
        invstgdr = KrnInvDenuncia.find(oid).krn_denuncia.krn_investigadores.last
      when 'dclrcn'
        invstgdr = KrnDeclaracion.find(oid).ownr.krn_denuncia.krn_investigadores.last
      end

      {nombre: invstgdr.blank? ? nil : invstgdr.krn_investigador, email: invstgdr.blank? ? nil : invstgdr.email}
    end

#    def get_pdf_data(dstntr, oid, rprt)
#      # Generar el PDF
#      WickedPdf.new.pdf_from_string(
#        render_to_string(
#          template: "rprts/krn_reportes/#{rprt}",
#          layout: 'pdf',
#          formats: [:pdf],  # ← Esto es clave para que busque .pdf.erb
#          locals: {dstntr: dstntr, objt: get_objt(oid, rprt)}
#        )
#      )
#    end

    def get_pdf_data(dstntr, oid, rprt)
      # return unless rprt == 'dnnc'
      # <<< CASO ESPECIAL: dnnc con Grover >>>
      if rprt == 'dnnc'
        html = render_to_string(
          template: "rprts/krn_reportes/dnnc",
          layout:    'pdf',
          formats:   [:html],        # importante: no :pdf
          locals:    { dstntr: dstntr, objt: get_objt(oid, rprt) }
        )

  # ===== DEBUG =====
  FileUtils.mkdir_p(Rails.root.join('tmp/grover'))
  File.write(Rails.root.join('tmp/grover/dnnc_last.html'), html)
  Rails.logger.info "[Grover] HTML generado: #{html.bytesize / 1024} KB"
  # =================

        return Grover.new(html, format: 'A4', print_background: true).to_pdf
      end

      # <<< RESTO DE REPORTES – WickedPDF sin cambios >>>
      WickedPdf.new.pdf_from_string(
        render_to_string(
          template: "rprts/krn_reportes/#{rprt}",
          layout: 'pdf',
          formats: [:pdf],
          locals: { dstntr: dstntr, objt: get_objt(oid, rprt) }
        )
      )
    end

    def get_dstntrs(oid, rprt)
      @pdf_archivo = PdfArchivo.find_by(codigo: rprt)
      dstntrs = []
      if rprt == 'dclrcn'
        dclrcn = KrnDeclaracion.find(oid)
        invstgdr = get_invstgdr(oid, rprt)
        rgstr = dclrcn.pdf_registros.find_by(pdf_archivo_id: @pdf_archivo.id, cdg: rprt)
        dstntrs << {objt: dclrcn.ownr, ref: dclrcn, invstgdr: invstgdr, nombre: dclrcn.ownr.nombre, rol: to_name(dclrcn.ownr), email: dclrcn.ownr.email} if rgstr.blank?
      elsif ['dnncnt_info_oblgtr', 'comprobante'].include?(rprt)  
        ref = get_objt(oid, rprt)
        invstgdr = get_invstgdr(oid, rprt)
        @objt['denunciantes'].each do |dnncnt|
          rgstr = dnncnt.pdf_registros.find_by(pdf_archivo_id: nil, cdg: rprt)
          dstntrs << {objt: dnncnt, ref: ref, invstgdr: invstgdr, nombre: dnncnt.nombre, rol: 'Denunciante', email: dnncnt.email} if rgstr.blank?
        end
      elsif ['medidas_resguardo'].include?(rprt)
        ref = get_objt(oid, rprt)
        invstgdr = get_invstgdr(oid, rprt)
        @objt['denunciantes'].each do |dnncnt|
          rgstr = dnncnt.pdf_registros.find_by(pdf_archivo_id: nil, cdg: rprt)
          dstntrs << {objt: dnncnt, ref: ref, invstgdr: invstgdr, nombre: dnncnt.nombre, rol: 'Denunciante', email: dnncnt.email} if rgstr.blank?
        end
        @objt['denunciados'].each do |dnncd|
          rgstr = dnncd.pdf_registros.find_by(pdf_archivo_id: nil, cdg: rprt)
          dstntrs << {objt: dnncd, ref: ref, invstgdr: invstgdr, nombre: dnncd.nombre, rol: 'Denunciante', email: dnncd.email} if rgstr.blank?
        end
      elsif ['drvcn', 'invstgdr', 'invstgcn', 'drchs'].include?(rprt)
        ref = get_objt(oid, rprt)
        invstgdr = get_invstgdr(oid, rprt)
        @objt['denunciantes'].each do |dnncnt|
          rgstr = dnncnt.pdf_registros.find_by(pdf_archivo_id: nil, cdg: rprt)
          dstntrs << {objt: dnncnt, ref: ref, invstgdr: invstgdr, nombre: dnncnt.nombre, rol: 'Denunciante', email: dnncnt.email} if rgstr.blank?
          dnncnt.krn_testigos.each do |tstg|
            t_rgstr = tstg.pdf_registros.find_by(pdf_archivo_id: nil, cdg: rprt)
            dstntrs << {objt: tstg, ref: ref, invstgdr: invstgdr, nombre: tstg.nombre, rol: 'Testigo', email: tstg.email} if t_rgstr.blank?
          end
        end
        @objt['denunciados'].each do |dnncd|
          rgstr = dnncd.pdf_registros.find_by(pdf_archivo_id: nil, cdg: rprt)
          dstntrs << {objt: dnncd, ref: ref, invstgdr: invstgdr, nombre: dnncd.nombre, rol: 'Denunciante', email: dnncd.email} if rgstr.blank?
          dnncd.krn_testigos.each do |tstg|
            t_rgstr = tstg.pdf_registros.find_by(pdf_archivo_id: nil, cdg: rprt)
            dstntrs << {objt: tstg, ref: ref, invstgdr: invstgdr, nombre: tstg.nombre, rol: 'Testigo', email: tstg.email} if t_rgstr.blank?
          end
        end
      elsif ['infrmcn'].include?(rprt)
        # Reporte de solicitud de Información
        ref = get_objt(oid, rprt)
        @objt['rrhh'].each do |rol|
          rgstrs = rol.pdf_registros.where(pdf_archivo_id: @pdf_archivo.id, ref_id: ref.id, cdg: rprt)
          dstntrs << {objt: rol, ref: ref, nombre: rol.nombre, rol: 'RRHH', email: rol.email} if (rgstrs.empty? or rgstrs.count < 3)
        end
      elsif ['crdncn_apt'].include?(rprt)
        # Reporte de solicitud de Información
        ref = get_objt(oid, rprt)
        @objt['crdncn_apt'].each do |rol|
          rgstrs = rol.pdf_registros.where(pdf_archivo_id: @pdf_archivo&.id, ref_id: ref.id, cdg: rprt)
          dstntrs << {objt: rol, ref: ref, nombre: rol.nombre, rol: 'Apt', email: rol.email} if (rgstrs.empty? or rgstrs.count < 3)
        end
      end

      dstntrs
    end

end
