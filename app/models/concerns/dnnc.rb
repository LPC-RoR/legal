module Dnnc
 	extend ActiveSupport::Concern

	PRESENTADORES = ['Denunciante', 'Representante']

	def css_id
		'dnnc'
	end

	# --------------------------------------------------------------------------------------------- VALORES
	# Usamos esta función porque no está clara la utilidad de Concern Valores
	def valor(variable_nm)
		variable = Variable.find_by(variable: variable_nm)
		variable.blank? ? nil : self.valores.find_by(variable_id: variable.id)
	end

	# ------------------------------------------------------------------------ INGRS

	def prsncl?
		self.via_declaracion == KrnDenuncia::VIAS_DENUNCIA[0]
	end

	def rprsntnt?
		self.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1]
	end

	def end_drv_dt?
		self.drv_dt? ? self.fecha_hora_dt.present? : true
	end

	def end_rcp_externa?
		self.rcp_externa? ? self.krn_empresa_externa.present? : true
	end

	def end_prsncl?
		self.prsncl? ? self.tipo_declaracion.present? : true
	end

	def end_rprsntnt?
		self.rprsntnt? ? self.representante.present? : true
	end

	def end_ingrs?
		self.end_drv_dt? and self.end_rcp_externa? and self.end_prsncl? and self.end_rprsntnt?
	end

	# ------------------------------------------------------------------------ PRTCPNTS

	def dnncnts?
		self.krn_denunciantes.any?
	end

	def dnncds?
		self.krn_denunciados.any?
	end

	def prtcpnts?
		self.no_vlnc? ? (self.dnncnts? and self.dnncds?) : self.dnncnts?
	end

	def no_vlnc?
		self.motivo_denuncia != KrnDenuncia::MOTIVOS[2]
	end

	def prtcpnts_ingrs?
		self.prtcpnts? and (not self.krn_denunciantes.rgstrs_fail?)
	end

	def prtcpnts_ok?
		dnncnts_ok = (not self.krn_denunciantes.rgstrs_fail?)
		dnncds_ok = self.no_vlnc? ? (not self.krn_denunciados.rgstrs_fail?) : true
		self.prtcpnts? and dnncnts_ok and dnncds_ok
	end

	# ------------------------------------------------------------------------ MDDS

	def mdds?
		dc = RepDocControlado.find_by(codigo: 'mdds_rsgrd')
		dc.blank? ? false : self.rep_archivos.where(rep_doc_controlado_id: dc.id).present?
	end

	# ------------------------------------------------------------------------ DIAT/DIEP

	# ------------------------------------------------------------------------ SGMNT

	def dsply_sgmnt?
		self.prtcpnts_ingrs? and (self.rcp_dt? or self.drv_dt? or self.externa?) and (self.drvcn_rchzd? or self.sgmnt_drvcn_externa?)
	end

	def drvcn_rchzd?
		self.rcp_externa? and self.externa? and (self.seguimiento? == false)
	end

	def sgmnt_drvcn_externa?
		self.rcp_externa? and self.externa?
	end

	def dnnc_sgmnt_end?
		self.sgmnt_drvcn_externa? ? self.vlr_flg_sgmnt? : true
	end

	# ------------------------------------------------------------------------ DRVCNS

	def dsply_drvcns?
		self.dnnc_sgmnt_end? and self.prtcpnts_ingrs? and self.mdds?
	end

	def rcpcn?
		self.rcp_externa? and self.empresa?
	end

	def rcpcnd?
		self.rcpcn? and ( self.krn_derivaciones.map {|drv| drv.tipo}.include?('Recepción') )
	end

	def extrn_prsncl?
		self.rcp_empresa? and self.externa?
	end

	def drvcns_on?
		self.rcpcn? ? self.rcpcnd? : (self.rcp_dt? ? false : self.empresa?)
	end

	def riohs_off?
		false
	end

	# A alguno de los participantes se le aplica el Artículo 4 parrafo 1
	def art4_1?
		self.krn_denunciantes.art4_1? or self.krn_denunciados.art4_1?
	end

	def dt_obligatoria?
		self.extrn_prsncl? ? self.art4_1? : (self.riohs_off? or self.art4_1?)
	end

	def drvcns?
		self.krn_derivaciones.any?
	end

	def no_drvcns?
		self.krn_derivaciones.empty?
	end

	def dnnc_drvcns_end?
		self.dnnc_sgmnt_end? and (self.rcp_dt? or self.drv_dt? or self.drv_externa? or self.vlr_e_optn_invstgcn?)
	end

	def invstgcn_on?
		self.invstgcn_emprs? or self.invstgcn_dt? or self.invstgcn_extrn?
	end


	# ------------------------------------------------------------------------ INFRMCN_DT
	# ------------------------------------------------------------------------ INVSTGCN

	def invstgdr?
		self.krn_investigador_id.present?
	end

	def eval?
		self.vlr_dnnc_incmplt? and self.vlr_dnnc_incnsstnt?
	end

	def dnnc_ok?
		(self.dnnc_incnsstnt? == false and self.dnnc_incmplt? == false) or self.fecha_hora_corregida.present?
	end

	def any_dclrcn?
		self.krn_denunciantes.map {|dte| dte.dclrcn?}.include?(true) or self.krn_denunciados.map {|dte| dte.dclrcn?}.include?(true)
	end

	def dclrcn?
		self.invstgcn_emprs? and self.any_dclrcn? and ( not self.krn_denunciantes.map {|dte| dte.dclrcn?}.include?(false) ) and ( not self.krn_denunciados.map {|dte| dte.dclrcn?}.include?(false) )
	end

	# ------------------------------------------------------------------------ CIERRE

	def sncns?
		dc = RepDocControlado.find_by(codigo: 'sncns')
		dc.blank? ? false : self.rep_archivos.where(rep_doc_controlado_id: dc.id).present?
	end

end