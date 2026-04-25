# Para manejar los reportes que generan PDF y se envían

class ClssPdfRprt


	# ********************************************************* NUEVA VERSION CENTRALIZADA DE REPORTES

	# Relaciona rprt con el modelo de la referencia
	# Por la url se pasa el nid
	RCRD_CLSS = {
		medidas_resguardo: 	ActArchivo,
		invstgdr: 					KrnInvDenuncia,
		drvcn: 							KrnDerivacion,
		dclrcn: 						KrnDeclaracion,
		crdncn_apt: 				KrnDenuncia,
		infrmcn: 						KrnDenuncia,
		dnnc: 							KrnDenuncia,
		txt_acta: 					KrnTexto,
		txt_mdds_rsgrd: 		KrnTexto,
		txt_dclrcn: 				KrnTexto,
		txt_infrm: 					KrnTexto
	}.freeze

	# ********************************************************* Destinatarios
	# El reporte debe ser enviado a las personas denunciantes?
	def self.dnncnt_rprt?(rprt)
		['dnncnt_info_oblgtr', 'comprobante', 'invstgcn', 'drchs', 'medidas_resguardo', 'txt_mdds_rsgrd', 'txt_acta', 'invstgdr', 'drvcn'].include?(rprt)
	end

	# El reporte debe ser enviado a las personas denunciados?
	def self.dnncd_rprt?(rprt)
		['invstgcn', 'drchs', 'medidas_resguardo', 'txt_mdds_rsgrd', 'invstgdr', 'drvcn'].include?(rprt)
	end

	# El reporte debe ser enviado a las personas testigos?
	def self.tstg_rprt?(rprt)
		['drchs'].include?(rprt)
	end

	# El reporte debe ser enviado a contactos AppContacto
	def self.cntct_rprt?(rprt)
		['crdncn_apt', 'infrmcn'].include?(rprt)
	end

	# Reporte cuyo destinatario es el ownr del registro notificador
	def self.ownr_rprt?(rprt)
		['dclrcn', 'txt_dclrcn'].include?(rprt)
	end

	# El reporte no se envía, sólo se genera el PDF
	def self.no_email_rprt?(rprt)
		['txt_infrm'].include?(rprt)
	end

	# El PDF es un recurso
	def self.rcrs_rprt?(rprt)
		['dnnc'].include?(rprt)
	end

	# Tiene el mismo uso que arriba pero se usa para los reportes txt
	def self.txt_rcrs_rprt?(rprt)
		['txt_infrm'].include?(rprt)
	end

	# ********************************************************* D...

	# DEPRECATED Revisar
	def self.adjunto_subido?(rprt)
		['medidas_resguardo'].include?(rprt)
	end

	# Reportes y documentos controlados que son una lista
	def self.lista_rprt?(rprt)
		['medidas_resguardo', 'mdds_rsgrd', 'txt_mdds_rsgrd', 'drvcn', 'invstgdr', 'dclrcn', 'antecedentes', 'objecion_antcdnts', 'medidas_sanciones', 'apt'].include?(rprt)
	end

	# Reportes que se pueden generar|verificar más de una vez
	def self.mltpl_rprt(rprt)
		['infrmcn'].include?(rprt)
	end

	# El reporte es notificable: Primer caso 'mdds_rsgrd'
	def self.rprt_ntfcbl?
		{
			mdds_rsgrd: 'medidas_resguardo'
		}
	end

	def self.act_dnnc?
		{
			medidas_resguardo: 'mdds_rsgrd'
		}
	end

	def self.sbjcts
		{
			dnncnt_info_oblgtr:	'Entrega de información obligatoria para personas denunciantes - Ley 21.643',
			comprobante:				'Comprobante de recepción de denuncia - Ley 21.643',
			drchs:							'Derechos y obligaciones de los participantes - Ley 21.643',
			medidas_resguardo:  'Medidas de resguardo - Ley 21.643',
			txt_mdds_rsgrd:  		'Medidas de resguardo - Ley 21.643',
			txt_acta: 					'Acta de denuncia - Ley 21.643', 
			infrmcn:    				'Verificación de datos de los participantes - Ley 21.643',
			crdncn_apt: 				'Coordinación de atención psicológica temprana - Ley 21.643',
			drvcn:      				'Notificación de derivación de la denuncia - Ley 21.643',
			invstgcn:   				'Notificación de recepción de denuncia - Ley 21.643',
			invstgdr:   				'Notificación de asignación de investigador - Ley 21.643',
			dclrcn:     				'Citación a declarar - Ley 21.643'
		}.freeze
	end
	# ************************************************************************************************

	def self.dnnc_rprts
		['infrmcn', 'crdncn_apt', 'txt_infrm'].freeze
	end

	def self.dstn_rprts
		['dnncnt_info_oblgtr'].freeze
	end

	def self.rcrd_rprts
		['invstgdr', 'drvcn', 'dclrcn'].freeze
	end

	def self.attch_rprt
		['medidas_resguardo'].freeze
	end

	# Control de destinatarios

	def self.cntrl_dstntrs
		{
			krn_denunciantes: ['dnncnt_info_oblgtr', 'comprobante', 'drchs', 'invstgcn', 'medidas_resguardo', 'invstgdr', 'drvcn', 'dclrcn'],
			krn_denunciados: ['drchs', 'invstgcn', 'medidas_resguardo', 'invstgdr', 'drvcn', 'dclrcn'],
			krn_testigos: ['drchs', 'drvcn', 'dclrcn'],
			app_contactos: ['crdncn_apt', 'infrmcn']
		}.freeze
	end

	# Ubicacion de los reportes

	def self.shw_index(rprt)
		rprt == 'dnnc' ? 2 : (['invstgdr', 'drvcn'].include?(rprt) ? 0 : 1)
	end

	def self.rdrct_path(dnnc, rprt)
		"/krn_denuncias/#{dnnc.id}_#{ClssPdfRprt.shw_index(rprt)}"
	end

  # Métodos para el manejo de reportes TXT

  def self.txt_list
    {
      dnnc:   ['txt_mdds_rsgrd', 'txt_objcn_rslcn', 'txt_anlss', 'txt_infrm'],
      dnncnt: ['txt_rprsntcn', 'txt_slctd_516', 'txt_acta', 'txt_dclrcn'],
      dnncd:  ['txt_slctd_516', 'txt_dclrcn'],
      tstg:   ['txt_slctd_516', 'txt_dclrcn']
    }
  end

  # ******************************************** Manejo de ActArchivo y CheckRealizado en PDF controlado

  # Códigos de PDF excluibles
  # En KrnDenuncia no hay códigos excluibles
  def self.exclbl_pdf?(rprt)
  	['dclrcn'].include?(rprt)
  end

  # Códigos de PDF omitidos siempre
  def self.omtd_pdf?(rprt)
  	['txt_acta', 'txt_dclrcn'].include?(rprt)
  end

end