module Karin
  extend ActiveSupport::Concern


  def drvcn_text
    {
      rcpcn_extrn: {
        prmpt: 'La denuncia fue presentada en una empresa externa ¿Se trata de una derivación?',
        lbl: 'Recibir denuncia derivada desde una empresa externa.',
        gls: 'Denuncia recibida desde empresa externa.'
      },
      rcpcn_dt: {
        prmpt: 'Solicitud de devolución aceptada',
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
        'dnnc_evlcn'        => dnnc.evlcn_incnsstnt,
        'dnnc_corrgd'       => (dnnc.evlcn_incnsstnt and (not dnnc.evlcn_ok)),
        'infrm_invstgcn'    => ((dnnc.fechas_crr_rcpcn? or dnnc.on_dt?) and dnnc.chck_dvlcn?),
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

  # --------------------------------------------------------------------------------------------- CAMPOS DEL OWNR

  # Reemplazar a fll_fld generalizando y creando ctr_registro correspondiente
  def set_fld
    fecha = params[:k].start_with?('fecha_')
    mthd  = params[:k]
    vlr   = fecha ? Date.parse(params[mthd.to_sym]) : params[mthd.to_sym]

    @objeto[mthd] = vlr
    @objeto.save

    redirect_to @objeto
  end

end