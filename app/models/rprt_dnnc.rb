# app/reports/denuncia_report.rb
class RprtDnnc
  attr_reader :dnnc

  def initialize(dnnc)
    @dnnc = dnnc
  end

  # Único punto de entrada
  def to_h
    {
      identificador:           dnnc.identificador,
      ownr_type:               dnnc.ownr_type,
      razon_social:            dnnc.ownr.razon_social,
      fecha_hora:              dnnc.fecha_hora,           
      motivo:                  dnnc.motivo_denuncia,
      receptor:                receptor_text,
      empresa_externa:         empresa_externa,
      canal:                   canal_text,
      denunciante:             denunciante_text, 
      derivaciones:            dnnc.krn_derivaciones.order(:fecha).map {|drv| [drv.fecha, drv.codigo]},
      investigadores:          dnnc.krn_inv_denuncias.order(:created_at).map {|inv| [inv.krn_investigador.krn_investigador, inv.objetado]},
      estructura:              KrnDenuncia.estrctr.find(dnnc.id),
      prtcpnts_minimos:        participantes_minimos_text,
      coordinacion_apt:        coordinacion_apt_text,
      vrfccn_solicitada:       vrfccn_solicitada_text,
      dnncnt_invstgcn_local:   dnnct_invstgcn_local_text,
      invstgcn_local_externa:  invstgcn_local_externa_text,
      evlcn_ok:                evlcn_ok_text,
      plz_prnncmnt:            plz_prnncmnt_text,
    }
  end

  private

  def receptor_text
    case dnnc.receptor_denuncia
    when 'Empresa'
      'Denuncia recibida a través del canal oficial de denuncias de la empresa.'
    when 'Externa'
      "Denuncia recibida a través del canal oficial de denuncias de la empresa. #{empresa_externa}."
    else
      'Denuncia presentada en la Dirección del Trabajo.'
    end
  end

  def empresa_externa
    dnnc.receptor_denuncia == 'Externa' ? dnnc.krn_empresa_externa.razon_social : nil
  end

  def canal_text
    if dnnc.via_declaracion == 'Presencial'
      if dnnc.tipo_declaracion.downcase == 'escrita'
        cmplmnt = "de manera presencial y por escrito"
      else
        cmplmnt = "verbalmente de manera presencial"
      end
    else
      cmplmnt = "vía #{dnnc.via_declaracion.downcase}"
    end
    "Denuncia presentada #{cmplmnt}."
  end

  def denunciante_text
    dnnc.presentado_por == 'Denunciante' ? 'Denuncia ingresada directamente por la persona denunciante.' : 'Denuncia presentada por un tercero en representación de la persona denunciante.'
  end

  def participantes_minimos_text
    dnnc.prtcpnts_minimos? ? nil : 'Falta información respecto de uno o más participantes.'
  end

  def coordinacion_apt_text
    dnnc.ownr.coordinacion_apt ? "#{dnnc.apt_coordinada? ? 'Se coordinó' : 'No se ha coordinado, hasta la fecha,'} la recepción de atención psicológica temprana para la persona denunciante." : nil
  end

  def vrfccn_solicitada_text
    dnnc.ownr.verificacion_datos ? "#{dnnc.vrfccn_solicitada? ? 'Se solicitó' : 'No se ha solicitado, hasta la fecha,'} la verificación de la información correspondiente a los participantes." : nil
  end

  def dnnct_invstgcn_local_text
    dnnc.dnncnt_investigacion_local ? 'La persona denunciante manifestó su voluntad de que la investigación sea realizada por la empresa.' : nil
  end

  def invstgcn_local_externa_text
    dnnc.investigacion_local ? 'La empresa resolvió efectuar la investigación de la denuncia de manera interna.' : (dnnc.investigacion_externa ? 'La empresa externa resolvió efectuar la investigación de la denuncia de manera interna.' : nil)
  end

  def evlcn_ok_text
    (dnnc.evlcn_ok.nil? or dnnc.evlcn_ok) ? nil : 'La denuncia presenta inconsistencias, por lo que se devuelve a la persona denunciante para su corrección.'
  end

  def plz_prnncmnt_text
    dnnc.prnncmnt_vncd.nil? ? nil : (dnnc.prnncmnt_vncd ? 'El plazo establecido para el pronunciamiento de la Dirección del Trabajo ha vencido.' : nil)
  end

end