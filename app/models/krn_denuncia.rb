class KrnDenuncia < ApplicationRecord

	RECEPTORES = ['Empresa', 'Dirección del Trabajo', 'Empresa externa']
	MOTIVOS = ['Acoso laboral', 'Acoso sexual', 'Violencia en el trabajo ejercida por terceros']

	VIAS_DENUNCIA = ['Denuncia presencial', 'Correo electrónico', 'Plataforma']
	TIPOS_DENUNCIA = ['Escrita', 'Verbal']
	PRESENTADORES = ['Denunciante', 'Representante']

	belongs_to :ownr, polymorphic: true

	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_investigador, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :valores, as: :ownr

	has_many :krn_lst_medidas, as: :ownr
	has_many :krn_lst_modificaciones, as: :ownr

	has_many :krn_denunciantes
	has_many :krn_denunciados
	has_many :krn_derivaciones
	has_many :krn_declaraciones

	scope :ordr, -> { order(fecha_hora: :desc) }

	delegate :rut, to: :krn_empresa_externa, prefix: true

	def css_id
		'dnnc'
	end

	def cndtn_trsh
		{
			fecha: {
				cndtn: self.fecha?,
				trsh: (not self.via_declaracion?)
			},
			fecha_dt: {
				cndtn: self.fecha_dt?,
				trsh: true
			},
			externa_id: {
				cndtn: (self.krn_empresa_externa? or self.via_declaracion?),
				trsh: (not self.via_declaracion?)
			},
			via: {
				cndtn: self.via_declaracion?,
				trsh: (not self.tipo_declaracion?)
			},
			tipo: {
				cndtn: self.tipo_declaracion?,
				trsh: (not self.presentado_por?)
			},
			presentada: {
				cndtn: self.presentado_por?,
				trsh: (not self.representante?)
			},
			representante: {
				cndtn: self.representante?,
				trsh: (not false)
			},
			sgmnt_drvcn: {
				cndtn: self.vlr_seguimiento?,
				trsh: (not false)
			},
			drvcn_dnncnt: {
				cndtn: (self.extrn_prsncl? and (not self.derivable?)),
				trsh: (false)
			},
			inf_dnncnt: {
				cndtn: (self.vlr_inf_dnncnt?),
				trsh: (not self.vlr_d_optn_emprs?)
			},
			d_optn_emprs: {
				cndtn: (self.vlr_d_optn_emprs? or (not self.derivable?)),
				trsh: (not self.vlr_e_optn_emprs?)
			},
			e_optn_emprs: {
				cndtn: (self.vlr_e_optn_emprs? or (not self.derivable?)),
				trsh: (not self.invstgdr?)
			},
			invstgdr: {
				cndtn: self.invstgdr?,
				trsh: (not self.vlr_dnnc_leida?)
			},
			dnnc_leida: {
				cndtn: self.vlr_dnnc_leida?,
				trsh: (not self.vlr_dnnc_incnsstnt?)
			},
			dnnc_incnsstnt: {
				cndtn: self.vlr_dnnc_incnsstnt?,
				trsh: (not self.vlr_dnnc_incmplt?)
			},
			dnnc_incmplt: {
				cndtn: self.vlr_dnnc_incmplt?,
				trsh: (not false)
			},
			dnnc_infrm_dt: {
				cndtn: self.vlr_dnnc_infrm_dt?,
				trsh: (not false)
			}
		}
	end

	def cndtn(code)
		self.cndtn_trsh[code].blank? ? false : (self.cndtn_trsh[code][:cndtn].blank? ? false : self.cndtn_trsh[code][:cndtn])
	end

	def trsh(code)
		self.cndtn_trsh[code].blank? ? false : (self.cndtn_trsh[code][:trsh].blank? ? false : self.cndtn_trsh[code][:trsh])
	end

	# --------------------------------------------------------------------------------------------- VALORES

	def valor(variable_nm)
		variable = Variable.find_by(variable: variable_nm)
		variable.blank? ? nil : self.valores.find_by(variable_id: variable.id)
	end

	# ------------------------------------------------------------------------ PROCS
	# ------------------------------------------------------------------------ INGRS

	def fecha?
		 self.fecha_hora.present?
	end

	def fecha_dt?
		 self.fecha_hora_dt.present?
	end

	def fecha_legal
		self.drv_dt? ? self.fecha_hora_dt : self.fecha_hora
	end

	def fecha_legal?
		self.fecha_legal.present?
	end

	def rcp_dt?
		self.receptor_denuncia == RECEPTORES[1]
	end

	def rcp_empresa?
		self.receptor_denuncia == RECEPTORES[0]
	end

	def rcp_externa?
		self.receptor_denuncia == RECEPTORES[2]
	end

	def krn_empresa_externa?
		self.krn_empresa_externa.present?
	end

	def via_declaracion?
		self.via_declaracion.present?
	end

	def tipo_declaracion?
		self.tipo_declaracion.present?
	end

	def presentado_por?
		self.presentado_por.present?
	end

	def activa_representante?
		self.presentado_por == PRESENTADORES[1]
	end

	def representante?
		self.representante.present?
	end

	# ------------------------------------------------------------------------ SGMNT

	def dnnc_seguimiento?
		self.rcp_dt? or self.drv_dt? or self.externa?
	end

	def sgmnt_drvcn_externa?
		self.rcp_externa? and self.externa?
	end

	def vlr_seguimiento
		vlr = self.valor('Seguimiento')
		vlr.blank? ? nil : vlr
	end

	def vlr_seguimiento?
		self.vlr_seguimiento.present?
	end

	def seguimiento?
		self.vlr_seguimiento.blank? ? nil : self.vlr_seguimiento.c_booleano
	end

	def drvcn_rchzd?
		self.rcp_externa? and self.externa? and (self.seguimiento? == false)
	end

	# ------------------------------------------------------------------------ DRVCN

	def no_drvcns?
		self.krn_derivaciones.empty?
	end

	# Se distinguen tres estados, se diferencia si hay o no recepciones
	def drv_dt?
		self.no_drvcns? ? nil : self.krn_derivaciones.lst.dstn_dt?
	end

	def drv_empresa?
		self.no_drvcns? ? nil : self.krn_derivaciones.lst.dstn_empresa?
	end

	def drv_externa?
		self.no_drvcns? ? nil : self.krn_derivaciones.lst.dstn_externa?
	end

	def derivable?
		(self.drv_empresa? == nil) ? self.rcp_empresa? : self.drv_empresa?
	end

	def recibible?
		self.rcp_externa? and (self.empresa? or self.multiempresa?) and self.no_drvcns?
	end

	# El código verifica si es o no derivable
	def dt_obligatoria?
		self.riohs_off? or self.art4_1?
	end

	# RIOHS Aun no entra en vigencia
	# Esto no cubre el caso multiempresa, en el cual puede haber más de una fecha de activación!
	def riohs_off?
		false
	end

	# A alguno de los participantes se le aplica el Artículo 4 parrafo 1
	def art4_1?
		self.krn_denunciantes.art4_1? or self.krn_denunciados.art4_1?
	end

	def extrn_prsncl?
		self.rcp_empresa? and self.externa?
	end

	def vlr_inf_dnncnt
		vlr = self.valor('inf_dnncnt')
		vlr.blank? ? nil : vlr
	end

	def vlr_inf_dnncnt?
		self.vlr_inf_dnncnt.present?
	end

	def inf_dnncnt?
		self.vlr_inf_dnncnt.blank? ? nil : self.vlr_inf_dnncnt.c_booleano
	end

	def vlr_d_optn_emprs
		vlr = self.valor('d_optn_emprs')
		vlr.blank? ? nil : vlr
	end

	def vlr_d_optn_emprs?
		self.vlr_d_optn_emprs.present?
	end

	def d_optn_emprs?
		self.vlr_d_optn_emprs.blank? ? nil : self.vlr_d_optn_emprs.c_booleano
	end

	def vlr_e_optn_emprs
		vlr = self.valor('e_optn_emprs')
		vlr.blank? ? nil : vlr
	end

	def vlr_e_optn_emprs?
		self.vlr_e_optn_emprs.present?
	end

	def e_optn_emprs?
		self.vlr_e_optn_emprs.blank? ? nil : self.vlr_e_optn_emprs.c_booleano
	end

	# ------------------------------------------------------------------------ MDDS DE RESGUARDO

	def dsply_mdds?
		self.krn_denunciantes.any? and self.krn_denunciados.any?
	end

	def mdds?
		self.krn_lst_medidas.any?
	end

	# ------------------------------------------------------------------------ COMPETENCIA DE INVESTIGAR

	def emprss_ids
		( self.krn_denunciantes.emprss_ids + self.krn_denunciados.emprss_ids ).compact.uniq
	end

	def empresa?
		ids = self.emprss_ids
		ids.length == 1 and ids[0] == nil
	end

	def externa?
		ids = self.emprss_ids
		ids.length == 1 and ids[0] != nil
	end

	def multiempresa?
		self.emprss_ids.length > 1
	end

	# ------------------------------------------------------------------------ INVSTGCN

	def investigable?
		self.no_drvcns? ? self.rcp_empresa? : self.drv_empresa?
	end

	def invstgdr?
		self.krn_investigador_id.present?
	end

	def vlr_dnnc_leida
		vlr = self.valor('dnnc_leida')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_leida?
		self.vlr_dnnc_leida.present?
	end

	def dnnc_leida?
		self.vlr_dnnc_leida.blank? ? nil : self.vlr_dnnc_leida.c_booleano
	end

	def vlr_dnnc_incnsstnt
		vlr = self.valor('dnnc_incnsstnt')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_incnsstnt?
		self.vlr_dnnc_incnsstnt.present?
	end

	def dnnc_incnsstnt?
		self.vlr_dnnc_incnsstnt.blank? ? nil : self.vlr_dnnc_incnsstnt.c_booleano
	end

	def vlr_dnnc_incmplt
		vlr = self.valor('dnnc_incmplt')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_incmplt?
		self.vlr_dnnc_incmplt.present?
	end

	def dnnc_incmplt?
		self.vlr_dnnc_incmplt.blank? ? nil : self.vlr_dnnc_incmplt.c_booleano
	end

	def eval?
		self.vlr_dnnc_incmplt? and self.vlr_dnnc_incnsstnt?
	end

	def dnnc_ok?
		self.dnnc_incnsstnt? == false and self.dnnc_incmplt? == false
	end

	# ------------------------------------------------------------------------ INVSTGCN

	def vlr_dnnc_infrm_dt
		vlr = self.valor('dnnc_infrm_dt')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_infrm_dt?
		self.vlr_dnnc_infrm_dt.present?
	end

	def dnnc_infrm_dt?
		self.vlr_dnnc_infrm_dt.blank? ? nil : self.vlr_dnnc_infrm_dt.c_booleano
	end



	def invstgdr_dt?
		self.drv_dt? or self.rcp_dt?
	end

	def entdd_invstgdr
		ids = self.emprss_ids
		self.invstgdr_dt? ? 'Dirección del Trabajo' : ( ids.length == 1 ? ( ids.first.blank? ? 'Empresa' : 'Empresa externa' ) : 'Empresa' )
	end



	# --------------------------------------------------------------------------------------------- MDDS
	# --------------------------------------------------------------------------------------------- DOCUMENTOS CONTROLADOS

	def dc_denuncia
		RepDocControlado.denuncia
	end

	def fl_denuncia
		dc = self.dc_denuncia
		dc.blank? ? nil : self.rep_archivos.get_dc_archv(dc)
	end

	def dc_corregida
		RepDocControlado.corregida
	end

	def fl_corregida
		dc = self.dc_corregida
		dc.blank? ? nil : self.rep_archivos.get_dc_archv(dc)
	end

	def fl_denuncia?
		self.fl_denuncia.present?
	end

	def fl_corregida?
		self.fl_corregida.present?
	end

end
