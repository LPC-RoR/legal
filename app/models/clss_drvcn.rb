# Sólo una clase para manejar el procedimiento
# app/models/procedimiento.rb
class ClssDrvcn

	HSH_TXTS = {
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
      }
	}.freeze

	# drvcn_ext_dt: Imagino que se hizo para señalar que la empresa externa derivó a la DT
	# Si la uso tengo que transformarla en 3 (asociadas a las 3 primeras)
	DRVCN_CDGS = ['drvcn_art4_1', 'drvcn_dnncnt', 'drvcn_emprs', 'drvcn_ext', 'drvcn_ext_dt'].freeze
	RCPCN_CDGS = ['rcpcn_extrn', 'rcpcn_dt'].freeze

	DESTN_EXTRN_CDGS = ['drvcn_ext'].freeze

	def self.valid?(cdg)
		DRVCN_CDGS.include?(cdg) or RCPCN_CDGS.include?(cdg)
	end

	def self.tipo(cdg)
		DRVCN_CDGS.include?(cdg) ? 'Derivación' : (RCPCN_CDGS.include?(cdg) ? 'Recepción' : nil)
	end

	def self.destino(cdg)
		RCPCN_CDGS.include?(cdg) ? KrnDenuncia::RECEPTORES[0] : (DESTN_EXTRN_CDGS.include?(cdg) ? KrnDenuncia::RECEPTORES[1] : KrnDenuncia::RECEPTORES[2])
	end

  def self.glosa(sym)
    HSH_TXTS[sym][:gls]
  end

end