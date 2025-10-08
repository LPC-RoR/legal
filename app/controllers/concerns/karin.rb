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