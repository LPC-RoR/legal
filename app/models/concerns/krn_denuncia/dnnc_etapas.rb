module KrnDenuncia::DnncEtapas
 	extend ActiveSupport::Concern
 	# 1ra implementación: Manejo de formularios por etápa específica
 	# 2da implementación: Botones para cambio de etapa de una denuncia específica

 	# Estos arrays determinan que campos se permite modificar en cada etapa
    FLDS_RCPCN =		[:ownr_type, :ownr_id, :fecha_hora, :identificador, :motivo_denuncia, :receptor_denuncia, :krn_empresa_externa_id, 
    	:via_declaracion, :tipo_declaracion, :presentado_por, :representante, :lugar_ocurrencia, :direccion_ocurrencia, :dnncnt_optn_invstgcn, 
    	:emprs_optn_invstgcn, :vrfccn_dts_incmbnts]
    FLDS_INVSTGCN =		[:evlcn_dnnc, :fecha_dnnc_crrgd, :vrfccn_dts_tstgs, :fecha_termino_investigacion]
    FLDS_INFRM =		[]
    FLDS_PRNNCMNT =		[:fecha_recepcion_pronunciamiento, :prnncmnt_vncd, :prnncmnt]
    FLDS_MDDS_SNCNS =	[:causal_establecida]
    FLDS_CERRADA =		[]


	# Campos que se definen en cada etapa
	CAMPOS_ETAPA = {
	    etp_rcpcn:		FLDS_RCPCN,
	    etp_invstgcn:	FLDS_INVSTGCN,
	    etp_infrm:		FLDS_INFRM,
	    etp_prnncmnt:	FLDS_PRNNCMNT,
	    etp_mdds_sncns:	FLDS_MDDS_SNCNS,
	    etp_cerrada:	FLDS_CERRADA
	}.freeze

	# Al inicio de la clase
	# Usados para el cambio de etapa (botones)
	ETAPAS = %w[etp_rcpcn etp_invstgcn etp_infrm etp_prnncmnt etp_mdds_sncns etp_cerrada].freeze

	# Dentro de la clase
	# 2da Detemina cuando una etapa está completa
	def etapa_completa?
	  case etapa
	  when 'etp_rcpcn'										
	    tramite_aviso_inicio || tramite_derivacion_dt		# 1ra versión
	  when 'etp_invstgcn'
	    fecha_termino_investigacion  						# 1ra versión
	  when 'etp_infrm'
	    tramite_deposito  									# 1ra versión
	  when 'etp_prnncmnt'
	    fecha_recepcion_pronunciamiento || prnncmnt_vncd	# 1ra versión
	  when 'etp_mdds_sncns'
	    fecha_mas_reciente_txt_mdds_sncns					# 1ra versión
	  else
	    true
	  end
	end

	# 2da
	def puede_avanzar?
	  may_avanzar? && etapa_completa?
	end

	# 2da
	def puede_retroceder?(usuario)
	  usuario.admin? && may_retroceder?
	end

	private

	# Métodos usados en los formularios por etapa
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