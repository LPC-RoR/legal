class KrnDenuncia < ApplicationRecord
	belongs_to :cliente, optional: true
	belongs_to :motivo_denuncia
	belongs_to :receptor_denuncia

	belongs_to :krn_investigador, optional: true

	has_many :rep_archivos, as: :ownr

	has_many :krn_denunciantes
	has_many :krn_denunciados
	has_many :krn_derivaciones

	scope :ordr, -> { order(fecha_hora: :desc) }

	def self.doc_cntrlds
		StModelo.get_model('KrnDenuncia').rep_doc_controlados.ordr
	end

	# Ids de las empresas externas. nil => Empresa principal
	# No hemos resuelto manejo de subcontratos y ASTs
	def emprss_ids
		( self.krn_denunciantes.emprss_ids + self.krn_denunciados.emprss_ids ).uniq
	end

	def invstgdr_dt?
		self.drv_dt? or rcp_dt?
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

	def art4_1?
		self.krn_denunciantes.art4_1? or self.krn_denunciados.art4_1?
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

	def riohs_on?
		true
	end

	def i_optns?
		self.info_opciones.present?
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
