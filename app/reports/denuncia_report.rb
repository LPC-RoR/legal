# app/reports/denuncia_report.rb
class DenunciaReport
  attr_reader :denuncia

  def initialize(denuncia)
    @denuncia = denuncia
  end

  # Único punto de entrada
  def to_h
    {
      identificador:           denuncia.identificador,
      ownr_type:               denuncia.ownr_type,
      razon_social:            denuncia.ownr.razon_social,
      fecha_hora:              denuncia.fecha_hora,           
      motivo:                  denuncia.motivo_denuncia,
      receptor:                receptor_text,
      empresa_externa:         empresa_externa,
      canal:                   canal_text,
      denunciante:             denunciante_text, 
      derivaciones:            denuncia.krn_derivaciones.order(:fecha).map {|drv| [drv.fecha, drv.codigo]},
      investigadores:          denuncia.krn_inv_denuncias.order(:created_at).map {|inv| [inv.krn_investigador.krn_investigador, inv.objetado]},
      estructura:              KrnDenuncia.estrctr.find(denuncia.id),
      prtcpnts_minimos:        participantes_minimos_text,
      coordinacion_apt:        coordinacion_apt_text,
      infrmcn_slctd:           infrmcn_slctd_text,
      dnncnt_invstgcn_local:   dnnct_invstgcn_local_text,
      invstgcn_local_externa:  invstgcn_local_externa_text,
      evlcn_ok:                evlcn_ok_text,
      plz_prnncmnt:            plz_prnncmnt_text,
#      involucrados_cantidad:   denuncia.involucrados.count,
#      archivos_cantidad:       denuncia.archivos.count,
#      ultima_actualizacion:    denuncia.updated_at,
      # …agregás lo que necesites…
    }
  end

  private

  def receptor_text
    case denuncia.receptor_denuncia
    when 'Empresa'
      'Denuncia recibida a través del canal oficial de denuncias de la empresa.'
    when 'Externa'
      "Denuncia recibida a través del canal oficial de denuncias de la empresa. #{empresa_externa}."
    else
      'Denuncia presentada en la Dirección del Trabajo.'
    end
  end

  def empresa_externa
    denuncia.receptor_denuncia == 'Externa' ? denuncia.krn_empresa_externa.razon_social : nil
  end

  def canal_text
    if denuncia.via_declaracion == 'Presencial'
      if denuncia.tipo_declaracion.downcase == 'escrita'
        cmplmnt = "de manera presencial y por escrito"
      else
        cmplmnt = "verbalmente de manera presencial"
      end
    else
      cmplmnt = "vía #{denuncia.via_declaracion.downcase}"
    end
    "Denuncia presentada #{cmplmnt}."
  end

  def denunciante_text
    denuncia.presentado_por == 'Denunciante' ? 'Denuncia ingresada directamente por la persona denunciante.' : 'Denuncia presentada por un tercero en representación de la persona denunciante.'
  end

  def participantes_minimos_text
    denuncia.prtcpnts_minimos? ? nil : 'Falta información respecto de uno o más participantes.'
  end

  def coordinacion_apt_text
    denuncia.ownr.coordinacion_apt ? "#{denuncia.apt_coordinada? ? 'Se coordinó' : 'No se ha coordinado, hasta la fecha,'} la recepción de atención psicológica temprana para la persona denunciante." : nil
  end

  def infrmcn_slctd_text
    denuncia.ownr.verificacion_datos ? "#{denuncia.infrmcn_slctd? ? 'Se solicitó' : 'No se ha solicitado, hasta la fecha,'} la verificación de la información correspondiente a los participantes." : nil
  end

  def dnnct_invstgcn_local_text
    denuncia.dnncnt_investigacion_local ? 'La persona denunciante manifestó su voluntad de que la investigación sea realizada por la empresa.' : nil
  end

  def invstgcn_local_externa_text
    denuncia.investigacion_local ? 'La empresa resolvió efectuar la investigación de la denuncia de manera interna.' : (denuncia.investigacion_externa ? 'La empresa externa resolvió efectuar la investigación de la denuncia de manera interna.' : nil)
  end

  def evlcn_ok_text
    (denuncia.evlcn_ok.nil? or denuncia.evlcn_ok) ? nil : 'La denuncia presenta inconsistencias, por lo que se devuelve a la persona denunciante para su corrección.'
  end

  def plz_prnncmnt_text
    denuncia.prnncmnt_vncd.nil? ? nil : (denuncia.prnncmnt_vncd ? 'El plazo establecido para el pronunciamiento de la Dirección del Trabajo ha vencido.' : nil)
  end

end