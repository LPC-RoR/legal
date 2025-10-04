# Para manejar los reportes que generan PDF y se envían
# krn_reportes_controller

class ClssPdfRprt

	RCRD_CLSS = {
		invstgdr: KrnInvDenuncia,
		drvcn: KrnDerivacion,
		dclrcn: KrnDeclaracion
	}.freeze

	  def self.sbjcts
	    {
	      infrmcn:    'Verificación de datos de los participantes.',
	      crdncn_apt: 'Coordinación de atención psicológica temprana.',
	      drvcn:      'Notificación de derivación de la denuncia.',
	      invstgcn:   'Notificación de recepción de denuncia.',
	      invstgdr:   'Notificación de asignación de Investigador.',
	      dclrcn:     'Citación a declarar.'
	    }.freeze
	  end

	def self.dnnc_rprts
		['infrmcn', 'crdncn_apt'].freeze
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
			krn_testigos: ['drchs', 'invstgcn', 'invstgdr', 'drvcn', 'dclrcn'],
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

end