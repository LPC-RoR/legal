class KrnDenuncia < ApplicationRecord
	belongs_to :ownr, polymorphic: true
	belongs_to :motivo_denuncia
	belongs_to :receptor_denuncia

	belongs_to :krn_investigador, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :krn_lst_medidas, as: :ownr
	has_many :krn_lst_modificaciones, as: :ownr

	has_many :krn_denunciantes
	has_many :krn_denunciados
	has_many :krn_derivaciones
	has_many :krn_declaraciones

	scope :ordr, -> { order(fecha_hora: :desc) }

	def css_id
		'dnnc'
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnDenuncia').rep_doc_controlados.ordr
	end

	# Ids de las empresas externas. nil => Empresa principal
	# No hemos resuelto manejo de subcontratos y ASTs
	def emprss_ids
		( self.krn_denunciantes.emprss_ids + self.krn_denunciados.emprss_ids ).uniq
	end

	def invstgdr_dt?
		self.drv_dt? or self.rcp_dt?
	end

	def por_representante?
		self.presentado_por == 'Representante'
	end

	# ------------------------------------------------------------------------ DERIVACION
	def multiempresa?
		self.emprss_ids.length > 1
	end

	def empresa_externa?
		ids = self.emprss_ids
		ids.length == 1 and ids[0] != nil
	end

	def rcp_dt?
		self.receptor_denuncia.dt?
	end

	def rcp_empresa?
		self.receptor_denuncia.empresa?
	end

	def rcp_externa?
		self.receptor_denuncia.externa?
	end

	def drv_dt?
		self.krn_derivaciones.empty? ? nil : self.krn_derivaciones.lst.dstn_dt?
	end

	def drv_empresa?
		self.krn_derivaciones.empty? ? nil : self.krn_derivaciones.lst.dstn_empresa?
	end

	def drv_externa?
		self.krn_derivaciones.empty? ? nil : self.krn_derivaciones.lst.dstn_externa?
	end

	def derivable?
		(self.drv_empresa? == nil) ? self.rcp_empresa? : self.drv_empresa?
	end

	def recibible?
		(self.drv_externa? == nil) ? self.rcp_externa? : self.drv_externa?
	end

	def art4_1?
		self.krn_denunciantes.art4_1? or self.krn_denunciados.art4_1?
	end

	def riohs_off?
		false
	end

	def i_optns?
		self.info_opciones.present?
	end

	def inf_dnncnt?
		self.info_opciones == true
	end

	def d_optn?
		self.dnncnt_opcion.present?
	end

	def e_optn?
		self.emprs_opcion.present?
	end

	def invstgdr?
		self.krn_investigador_id.present?
	end

	def leida?
		self.leida == true
	end

	def incnsstnt_ok?
		self.incnsstnt != nil
	end

	def incmplt_ok?
		self.incmplt != nil
	end

	def no_eval?
		self.incnsstnt == nil and self.incmplt == nil
	end

	def eval?
		self.incnsstnt != nil and self.incmplt != nil
	end

	def dnnc_ok?
		self.incnsstnt == false and self.incmplt == false
	end

	def dnnc_errr?
		self.incnsstnt == true or self.incmplt == true
	end

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

	# ------------------------------------------------------------------------ 

	def agndmnt?
		self.eval? and ( self.dnnc_errr? ? self.fl_corregida? : self.fl_denuncia )
	end

	# ------------------------------------------------------------------------ 

	def entdd_invstgdr
		ids = self.emprss_ids
		self.invstgdr_dt? ? 'Dirección del Trabajo' : ( ids.length == 1 ? ( ids.first.blank? ? 'Empresa' : 'Empresa externa' ) : 'Empresa' )
	end

	def owner
#		self.cliente_id.blank? ? self.empresa : self.cliente
		self.cliente
	end

end
