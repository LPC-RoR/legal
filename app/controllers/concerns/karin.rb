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
    @proc = {}
    @proc[:fls_mss] = []
    @proc[:fls_actv] = []
    @proc[:etp_last] = nil
    @proc[:tar_last] = nil
    @proc_objt = Procedimiento.find_by(codigo: 'krn_invstgcn')
    @proc_objt.ctr_etapas.ordr.each do |etp|
      if etp.dsply?(ownr) and etp_cntrl(ownr)[etp.codigo.to_sym]
        @proc[:etp_last] = etp

        etp.tareas.ordr.each do |tar|
          if tar.dsply?(ownr) and tar_cntrl(ownr)[tar.codigo] and ( not tar_hide(ownr, tar.codigo) )
            @proc[:tar_last] = tar
          end
        end
      else
        # break
      end
    end

    @proc_objt.rep_doc_controlados.ordr.each do |dc|
      if fl_cndtn?(ownr, dc.codigo)
        @proc[:fls_actv] << dc
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
        prmpt: 'La persona denunciante solicita derivar a la Dirección del Trabajo.',
        lbl: 'Derivar a la Dirección del Trabajo.',
        gls: 'Derivada a la Dirección del Trabajo ( Denunciante ).'
      },
      drvcn_emprs: {
        prmpt: 'La empresa decide derivar a la Dirección del Trabajo.',
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
        'dnnc_notificacion' => dnnc.rcp_dt?,
        'dnnc_certificado'  => (dnnc.on_dt? and dnnc.derivaciones?),
        'dnncnt_rprsntcn'   => (dnnc.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1]),
        'mdds_rsgrd'        => (( dnnc.rgstrs_ok? and ( not dnnc.on_empresa? ) ) or dnnc.investigacion_local),
        'antcdnts_objcn'    => dnnc.objcn_invstgdr,
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

  # --------------------------------------------------------------------------------------------- DNNC_JOT (JUST ONE TIME)
  def jot_cds
    [
      'p_plus',                   # Producto extendido
      'emprs_extrn_prsnt',        # Empresa externa presente
      'prsncl',                   # Denuncia entregada presencialmente
      'representante',            # Denuncia presentada por un representante
      'dt_obligatoria',           # Denuncia se debe derivar obligatoriamente a la DT
      'drvcn_rcbd',               # Denuncia que fue recibida por derivación
      'drvcns_any',               # Denuncia con derivaciones
      'vlr_drv_inf_dnncnt',       # Iforma al denunciante de sus opciones de investigación.
      'vlr_drv_dnncnt_optn',      # Opción del denunciante
      'frst_invstgdr',            # Denuncia con investigadores
      'vlr_dnnc_objcn_invstgdr',  # Campo de objeción del investigador presente
      'dnnc_objcn_invstgdr',      # Objeción del investigador
      'vlr_dnnc_rslcn_objcn',     # Campo resolucion presente
      'dnnc_rslcn_objcn',         # Resolución de la objeción
      'vlr_dnnc_eval_ok',         # Campo evaluación de denuncia
      'dnnc_eval_ok',             # Evaluación de la denuncia
      # TarControl
      'ingrs_dnnc_bsc',           # Ingreso de campos básicos de la denuncia
      'ingrs_nts_ds',             # Denunciantes ok e denunciados con información mínima
      'on_empresa',               # Denuncia en la empresa
      'vlr_sgmnt_emprs_extrn',    # Seguimiento de empresa externa
      'drv_dt',                   # Denuncia derivada a la DT
      'ingrs_fls_ok',             # Ingreso de archivos ok
      'prtcpnts_ok',              # Participantes OK
      'invstgdr_ok',              # Investigador OK
      'dclrcns_any',              # Alguna declaració,
      'dclrcns_ok',               # Declaraciones OK
      'envio_ok',                 # Informa a la DT, Certificado de recepción o Notificación de recepción de denuncia
      'on_dt',                    # Denuncia en la DT
      'dnncnts_any',              # Algún denunciante
      'tipo_declaracion_prsnt',   # Tipo de declaracion presente
      'representante_prsnt',      # Representante presente
      'drv_emprs_optn',           # Empresa opta por investigación en la empresa
      'fl_mdds_rsgrd',            # Hay algún archivo de Medidas de Resguardo
      'fecha_hora_dt_prsnt',      # Fecha hora DT presente
      'fecha_trmtcn_prsnt',       # Fecha de tramitación presente
      'fecha_ntfccn_prsnt',       # Fecha de notificación presente
      'fecha_ntfccn_invstgdr_prsnt', # Fecha de notificación de Investigador presente
      'scnd_invstgdr',            # Segundo investigador
      'fecha_hora_corregida_prsnt', # Fecha hora corregida presente
      'vlr_dnnc_crr_dclrcns',     # Cierre de declaraciones
      'vlr_dnnc_infrm_dt',        # Informe a la DT
      'fecha_trmn_prsnt',         # Fecha de tramitación presente
      'fecha_env_infrm_prsnt',    # Fecha envío informe
      'fecha_prnncmnt_prsnt',     # Fecha pronunciamiento presente
      'fecha_prcsd_prsnt',        # Fecha ...
      'dnncnts_rgstrs_ok',        # Registros de denunciantes OK
      'diat_diep_ok',             # DIAT/DIEP subido
      'no_vlnc',                  # Denuncia no es de violencia
      'dnncds_any',               # Algún denunciado
      'dnncds_rgstrs_ok',         # Denunciantes registros OK 
      'vlr_drv_emprs_optn',
    ]
  end

  def prtcpnts_cds
    [
      'emprs_extrn_prsnt',        # Empresa externa presente
      'drccn_ntfccn_prsnt',       # Dirección de notificación presente
      'vlr_dnnc_eval_ok',
      'dnnc_eval_ok',
      'on_empresa'
    ]
  end

  # --------------------------------------------------------------------------------------------- ACTIVE KARIN

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