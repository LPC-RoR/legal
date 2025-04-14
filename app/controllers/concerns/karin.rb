module Karin
  extend ActiveSupport::Concern

  def tar_fls_slctd(ownr, tar)
    fls = []
    tar.rep_doc_controlados.ordr.each do |dc|
      if fl_cndtn?(ownr, dc.codigo)
        unless ownr.fl?(dc.codigo)
          fls << dc.rep_doc_controlado
        end
      end
    end
    fls
  end

  def load_proc(ownr)
    @etp_cntrl_hsh = etp_cntrl_hsh(ownr)
    @tar_cntrl_hsh = tar_cntrl_hsh(ownr)
    @fls_actv = []
    @etps_trmnds = []
    @proc_objt = Procedimiento.find_by(codigo: 'krn_invstgcn')

    @proc_objt.ctr_etapas.ordr.each do |etp|

      if @etp_cntrl_hsh[etp.codigo][:trmn]
        @etps_trmnds << {codigo: etp.codigo, etapa: etp.ctr_etapa, plz_ok: @etp_cntrl_hsh[etp.codigo][:plz_ok], plz: @etp_cntrl_hsh[etp.codigo][:plz], plz_tag: @etp_cntrl_hsh[etp.codigo][:plz_tag]}
          @etp_last = etp
      else
        if @etp_cntrl_hsh[etp.codigo][:actv]
          @etp_last = etp

          etp.tareas.ordr.each do |tar|
            if @tar_cntrl_hsh[tar.codigo][:actv]
              @tar_last = tar
            end
          end
        end
        break
      end

    end

    def load_temas(ownr, hsh)
        unless ownr.blank?
          ownr.lgl_temas.each do |tm|
            mdl = tm.codigo[0] == 'd' ? 'LglDocumento' : (tm.codigo[0] == 'p' ? 'LglParrafo' : 'LglCita')
            tema = mdl.constantize.find_by(codigo: tm.codigo)
            hsh[tm.codigo] = tema
          end
        end
    end

    def load_temas_proc
      @lgl_temas = {}
      load_temas(@proc_objt, @lgl_temas)
      load_temas(@etp_last, @lgl_temas)
      load_temas(@tar_last, @lgl_temas)
    end

    @proc_objt.rep_doc_controlados.ordr.each do |dc|
      if fl_cndtn?(ownr, dc.codigo)
        @fls_actv << dc
      end
    end

  end

  def drvcn_text
    {
      rcpcn_extrn: {
        prmpt: 'La denuncia fue presentada en una empresa externa ¿Se trata de una derivación?',
        lbl: 'Recibir denuncia derivada desde una empresa externa.',
        gls: 'Denuncia recibida desde empresa externa.'
      },
      rcpcn_dt: {
        prmpt: 'Se solicitó la devolución de la denuncia a la Dirección del Trabajo',
        lbl: 'Recibir denuncia derivada desde la Dirección de Trabajo.',
        gls: 'Denuncia recibida desde la Dirección del Trabajo.'
      },
      drvcn_art4_1: {
        prmpt: 'Para alguno de los participantes aplica el artículo 4 inciso primero.',
        lbl: 'Derivar ( obligatoriamente ) a la Dirección del Trabajo.',
        gls: 'Derivada a la Dirección del Trabajo ( Artículo 4 inciso primero ).'
      },
      drvcn_dnncnt: {
        prmpt: 'La persona denunciante solicita derivar la denuncia a la Dirección del Trabajo.',
        lbl: 'Derivar a la Dirección del Trabajo.',
        gls: 'Derivada a la Dirección del Trabajo ( Denunciante ).'
      },
      drvcn_emprs: {
        prmpt: 'La empresa decide derivar la denuncia a la Dirección del Trabajo.',
        lbl: 'Derivar a la Dirección del Trabajo.',
        gls: 'Derivada a la Dirección del Trabajo ( Empresa ).'
      },
      drvcn_ext: {
        prmpt: 'Recepción de denuncia de empresa externa: derivar a la empresa externa.',
        lbl: 'Derivar a la empresa externa.',
        gls: 'Derivada a la empresa externa.'
      },
      drvcn_ext_dt: {
        prmpt: 'Recepción de denuncia de empresa externa: derivar a la Dirección del Trabajo.',
        lbl: 'Derivar a la Dirección del Trabajo.',
        gls: 'Derivada a la Dirección del Trabajo ( Externa ).'
      },
    }
  end

  # --------------------------------------------------------------------------------------------- GENERAL

  #Control de despliegue de Archivos

  def fl_dsply_hsh(ownr)
    dnnc = ownr.dnnc
    {
      dnnc: {
        'dnnc_denuncia'     => dnnc.tipo_declaracion != 'Verbal',
        'dnnc_acta'         => dnnc.tipo_declaracion == 'Verbal',
        'dnnc_antcdnts'     => true,
        'dnnc_notificacion' => dnnc.rcp_dt?,
        'dnnc_certificado'  => (dnnc.on_dt? and dnnc.derivaciones?),
        'dnncnt_rprsntcn'   => (dnnc.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1]),
        'mdds_rsgrd'        => (( dnnc.rgstrs_ok? and ( not dnnc.on_empresa? ) ) or dnnc.investigacion_local),
        'rslcn_dvlcn'       => dnnc.solicitud_denuncia,
        'antcdnts_objcn'    => (dnnc.investigadores? ? dnnc.krn_inv_denuncias.first.objetado : false),
        'rslcn_objcn'       => dnnc.fl?('antcdnts_objcn'),
        'dnnc_evlcn'        => (dnnc.on_empresa? and dnnc.krn_investigadores.any?),
        'dnnc_corrgd'       => (dnnc.evlcn_incmplt? or dnnc.evlcn_incnsstnt?),
        'infrm_invstgcn'    => dnnc.rlzds?,
        'mdds_crrctvs'      => dnnc.rlzds?,
        'sncns'             => dnnc.rlzds?,
        'prnncmnt_dt'       => dnnc.fecha_prnncmnt?,
        'dnnc_mdds_sncns'   => (dnnc.fecha_env_infrm? or dnnc.plz_prnncmnt_vncd?)
      },
      prtcpnts: {
        'dnncnt_diat_diep'  => ownr.class.name == 'KrnDenunciante',
        'prtcpnts_dclrcn'   => ownr.declaraciones?,
        'prtcpnts_antcdnts' => ownr.declaraciones?
      }
    }
  end

  def fl_cndtn?(ownr, codigo)
    ownr != ownr.dnnc ? fl_dsply_hsh(ownr)[:prtcpnts][codigo] : fl_dsply_hsh(ownr)[:dnnc][codigo]
  end

  # --------------------------------------------------------------------------------------------- CAMPOS DEL OWNR

  # Reemplazar a fll_fld generalizando y creando ctr_registro correspondiente
  def set_fld
    ctr_paso = CtrPaso.find_by(codigo: params[:k])

    @objeto[ctr_paso.metodo] = ctr_paso.metodo.split('_')[0] == 'fecha' ? params_to_date(params, ctr_paso.metodo) : params[ctr_paso.metodo.to_sym]
    @objeto.save

    dsply_metodo = ctr_paso.despliega.blank? ? ctr_paso.metodo : ctr_paso.despliega
    field = @objeto.send(dsply_metodo)


    if ctr_paso.metodo.split('_').first == 'fecha'
      vlr = @objeto[ctr_paso.metodo].strftime("%d-%m-%Y  %I:%M%p")
    elsif field.class.name == 'TrueClass'
      vlr = ''
    else
      vlr = @objeto.send(dsply_metodo)
    end

    @objeto.ctr_registros.create(orden: ctr_paso.orden, tarea_id: ctr_paso.tarea_id, ctr_paso_id: ctr_paso.id, glosa: ctr_paso.glosa, valor: vlr)

    redirect_to @objeto
  end

  # Complemento de set_fld
  def clear_fld
    ctr_paso = CtrPaso.find_by(codigo: params[:k])
    @objeto[ctr_paso.metodo] = nil
    @objeto.save
    ctr_registro = @objeto.ctr_registros.find_by(ctr_paso_id: ctr_paso.id)
    ctr_registro.delete

    redirect_to @objeto
  end


end