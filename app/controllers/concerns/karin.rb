module Karin
  extend ActiveSupport::Concern

  def load_objt(objt)
    @objt = {} if @objt.blank?
    @objt['denunciantes?'] = objt.krn_denunciantes.any?
    @objt['denunciados?'] = objt.krn_denunciados.any?
    @objt['declaraciones?'] = objt.krn_declaraciones.any?
    @objt['derivaciones?'] = objt.krn_derivaciones.any?
    @objt['investigadores?'] = objt.krn_investigadores.any?

    mthds = [
      'on_dt?', 'on_empresa?', 'rgstrs_ok?', 'motivo_vlnc?'
    ]
    mthds.each do |mthd|
      @objt[mthd] = objt.send(mthd)
    end
  end

  def load_objt_plzs(objt)
    @objt = {} if @objt.blank?

    # Siempre a partir de la fecha de tramitación.
    @objt['plz_rcpcn'] = plz_lv(objt.fecha_hora, 3)

    # Considera aun la fecha de devolución
    fecha_inicio_investigacion = objt.fecha_dvlcn? ? objt.fecha_dvlcn : (objt.fecha_hora_dt? ? objt.fecha_hora_dt : objt.fecha_hora)
    @objt['plz_invstgcn'] = plz_lv(fecha_inicio_investigacion, 30)

    # No calcula en función de la finalización efectiva
    # cuida el plazo máximo
    @objt['plz_infrm'] = plz_lv(@objt['plz_invstgcn'], 2)

    # REVISAR existencia de fecha_recep_infrm
    fecha_envio_rcpcn_infrm = (objt.fecha_env_infrm || objt.fecha_rcpcn_infrm)
    @objt['plz_prnncmnt'] = @objt['on_dt?'] ? nil : plz_lv(fecha_envio_rcpcn_infrm, 30)
    fecha_inicio_mdds_sncns = @objt['on_dt?'] ? fecha_envio_infrm : @objt['plz_prnncmnt']
    @objt['plz_mdds_sncns'] = plz_c(fecha_inicio_mdds_sncns, 15)
  end

  # Funciona con la carga histórica
  def etp_plz(etp_cdg)
    @objt[etp_cdg.gsub('etp_', 'plz_')]
  end

  # plz_ok? está en plazos
  def etp_plz_ok?(ownr)
    dnnc = ownr.dnnc
    {
      'etp_rcpcn'      => plz_ok?(dnnc.fecha_trmtcn, etp_plz('etp_rcpcn')),
      'etp_invstgcn'   => plz_ok?(dnnc.fecha_trmn, etp_plz('etp_invstgcn')),
      'etp_infrm'      => plz_ok?(dnnc.fecha_env_infrm, etp_plz('etp_infrm')),
      'etp_prnncmnt'   => dnnc.on_dt? ? false : plz_ok?(dnnc.fecha_prnncmnt, etp_plz('etp_prnncmnt')),
      'etp_mdds_sncns' => plz_ok?(dnnc.fecha_cierre, etp_plz('etp_mdds_sncns')),
    }
  end

  def etp_plz_left(ownr)
    dnnc = ownr.dnnc
    {
      'etp_rcpcn'       => lv_to_plz(dnnc.fecha_trmtcn, etp_plz('etp_rcpcn')),
      'etp_invstgcn'    => lv_to_plz(dnnc.fecha_trmn, etp_plz('etp_invstgcn')),
      'etp_infrm'       => lv_to_plz((dnnc.fecha_env_infrm || dnnc.fecha_rcpcn_infrm), etp_plz('etp_infrm')),
      'etp_prnncmnt'    => dnnc.on_dt? ? nil : lv_to_plz(dnnc.fecha_prnncmnt, etp_plz('etp_prnncmnt')),
      'etp_mdds_sncns'  => c_to_plz(dnnc.fecha_cierre, etp_plz('etp_mdds_sncns'))
    }
  end

  def load_proc(objt)
    load_objt_plzs(objt)

    @objt = {} if @objt.blank?

    @objt[:etp_cntrl] = etp_cntrl_hsh(objt, @objt)
    @objt[:tar_cntrl] = tar_cntrl_hsh(objt, @objt)

    @fls_actv = []
    @etps_trmnds = []
    @proc_objt = Procedimiento.find_by(codigo: 'krn_invstgcn')

    @proc_objt.ctr_etapas.ordr.each do |etp|

      if @objt[:etp_cntrl][etp.codigo][:trmn]
        @etps_trmnds << {
          codigo: etp.codigo, 
          etapa: etp.ctr_etapa, 
          plz: etp_plz(etp.codigo), 
          plz_ok: etp_plz_ok?(objt)[etp.codigo], 
          plz_tag: etp_plz_left(objt)[etp.codigo]
        }
          @etp_last = etp
      else
        if @objt[:etp_cntrl][etp.codigo][:actv]
          @etp_last = etp

          etp.tareas.ordr.each do |tar|
            if @objt[:tar_cntrl][tar.codigo][:actv]
              @tar_last = tar
            end
          end
        end
        break
      end

    end

    @proc_objt.rep_doc_controlados.ordr.each do |dc|
      if fl_cndtn?(objt, dc.codigo)
        @fls_actv << dc
      end
    end

  end

  def hsh_ownr_dcs(hsh, prcdmnt, ownr)
    fls = []
    prcdmnt.rep_doc_controlados.ordr.each do |dc|
      cond = hsh_fl_cndtn?(hsh, ownr, dc.codigo)
      if cond
        fls << dc
      end
    end
    fls
  end

  def load_p_fls
    proc_objt = Procedimiento.find_by(codigo: 'krn_invstgcn')
    @p_fls = {
      'KrnDenunciante' => {},
      'KrnDenunciado'  => {},
      'KrnTestigo'     => {}
    }
    @coleccion['krn_denunciantes'].each do |prtcpnt|
      hsh = fl_dsply_hsh(prtcpnt) if hsh.blank?
      dcs = hsh_ownr_dcs(hsh, proc_objt, prtcpnt) if dcs.blank?
      @p_fls[prtcpnt.class.name][prtcpnt.id] = dcs

      prtcpnt.krn_testigos.each do |tstg|
        thsh = fl_dsply_hsh(tstg) if thsh.blank?
        tdcs = hsh_ownr_dcs(thsh, proc_objt, tstg) if tdcs.blank?
        @p_fls[tstg.class.name][tstg.id] = tdcs
      end
    end

    @coleccion['krn_denunciados'].each do |prtcpnt|
      hsh = fl_dsply_hsh(prtcpnt) if hsh.blank?
      dcs = hsh_ownr_dcs(hsh, proc_objt, prtcpnt) if dcs.blank?
      @p_fls[prtcpnt.class.name][prtcpnt.id] = dcs

      prtcpnt.krn_testigos.each do |tstg|
        thsh = fl_dsply_hsh(tstg) if thsh.blank?
        tdcs = hsh_ownr_dcs(thsh, proc_objt, tstg) if tdcs.blank?
        @p_fls[tstg.class.name][tstg.id] = tdcs
      end
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
        'dnnc_corrgd'       => ((dnnc.evlcn_incmplt or dnnc.evlcn_incnsstnt) and (not dnnc.evlcn_ok)),
        'infrm_invstgcn'    => dnnc.fecha_trmn?,
        'mdds_crrctvs'      => dnnc.fecha_trmn?,
        'sncns'             => dnnc.fecha_trmn?,
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

  def hsh_fl_cndtn?(hsh, ownr, codigo)
    ownr != ownr.dnnc ? hsh[:prtcpnts][codigo] : hsh[:dnnc][codigo]
  end

  # --------------------------------------------------------------------------------------------- CAMPOS DEL OWNR

  # Reemplazar a fll_fld generalizando y creando ctr_registro correspondiente
  def set_fld
    fecha = params[:k].start_with?('fecha_')
    mthd  = params[:k]
    vlr   = fecha ? params_to_date(params, mthd) : params[mthd.to_sym]

    @objeto[mthd] = vlr
    @objeto.save

    redirect_to @objeto
  end

  # Complemento de set_fld
  def clear_fld
    mthd = params[:k]
    @objeto[mthd] = nil
    @objeto.save

    redirect_to @objeto
  end


end