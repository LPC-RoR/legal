# app/models/clss_cmbnd_invstgcns.rb
class ClssCmbndInvstgcns
  include ConditionalArray

  RCRSS_CDGS = [
    'dsgncn_invstgdr'
  ]

  def self.nombre
    {
      'dsgncn_invstgdr'     => 'Designación del investigador'
    }
  end

  def self.ref_ownr(ownr)
    case ownr.class.table_name
    when 'KrnDenuncia'
      "#{ownr.identificador} : "
    else
      nil
    end
  end

  def self.filename(ownr, code)
    "#{ref_ownr(ownr)}#{nombre[code]}"
  end

  def self.dsply_codes_for(ownr)
    items = CDGS[ownr.kywrd[:sym]] || []
    available_codes_for(ownr, items)
  end

  # ---------------------- Control de despliegue
  def self.has_one?(code)
    ['dsgncn_invstgdr'].include?(code)
  end

  # ---------------------- Control de despliegue (final)

  def self.ownr_blobs_for(ownr, code)
    case code
    when 'dsgncn_invstgdr'
      dsgncn = ownr.act_archivos.where(act_archivo: 'txt_invstgdr_dsgncn').order(:created_at).last
      titulos = ownr&.krn_inv_denuncias.order(:created_at)&.last&.krn_investigador&.act_archivos.where(act_archivo: 'invstgdr_titulo_prfsnl')
      if dsgncn.present? && titulos.any?
        ttls_blobs = titulos.map {|ttl| ttl.pdf.blob}
        [dsgncn.pdf.blob] + ttls_blobs
      else
        []
      end
    end
  end

end