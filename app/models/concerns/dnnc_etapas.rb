module DnncEtapas
 	extend ActiveSupport::Concern

    FLDS_RCPCN =		[:ownr_type, :ownr_id, :fecha_hora, :identificador, :etapa, :motivo_denuncia, :receptor_denuncia, :krn_empresa_externa_id, 
    	:via_declaracion, :tipo_declaracion, :presentado_por, :representante, :lugar_ocurrencia, :direccion_ocurrencia, :dnncnt_optn_invstgcn, 
    	:emprs_optn_invstgcn, :vrfccn_dts_incmbnts]
    FLDS_INVSTGCN =		[:denunciante_id, :abogado_id, :medidas_inmediatas]
    FLDS_INFRM =		[:hechos, :testigos, :evidencia_adjunta]
    FLDS_PRNNCMNT =		[:resolucion, :sancion, :fecha_cierre]
    FLDS_MDDS_SNCNS =	[:resolucion, :sancion, :fecha_cierre]
    FLDS_CERRADA =		[:resolucion, :sancion, :fecha_cierre]


	# Campos que se definen en cada etapa
	CAMPOS_ETAPA = {
	    etp_rcpcn:		FLDS_RCPCN,
	    etp_invstgcn:	FLDS_INVSTGCN,
	    etp_infrm:		FLDS_INFRM,
	    etp_prnncmnt:	FLDS_PRNNCMNT,
	    etp_mdds_sncns:	FLDS_MDDS_SNCNS,
	    etp_cerrada:	FLDS_CERRADA
	}.freeze


	private

	def campos_congelados_respetados
	    return unless etapa_was.present? && etapa_changed?

	    etapas_anteriores = CAMPOS_ETAPA.keys.take_while { |e| e != etapa.to_sym }
	    campos_prohibidos = etapas_anteriores.flat_map { |e| CAMPOS_ETAPA[e] }

	    campos_modificados = changed.map(&:to_sym)
	    violaciones = campos_modificados & campos_prohibidos

	    violaciones.each do |campo|
	      errors.add(campo, "no puede modificarse en la etapa #{etapa}")
	    end
	end

end