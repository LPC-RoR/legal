class KrnDenuncia < ApplicationRecord

	ACCTN = 'dnncs'

	RECEPTORES = ['Empresa', 'Dirección del Trabajo', 'Empresa externa']
	MOTIVOS = ['Acoso laboral', 'Acoso sexual', 'Violencia en el trabajo ejercida por terceros']

	VIAS_DENUNCIA = ['Denuncia presencial', 'Correo electrónico', 'Plataforma']
	TIPOS_DENUNCIA = ['Escrita', 'Verbal']

	include Dnnc

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

	def fecha_legal
		self.drv_dt? ? self.fecha_hora_dt : self.fecha_hora
	end

	def fecha_legal?
		self.fecha_legal.present?
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

	# ------------------------------------------------------------------------ RCPS & DRVS

	def rcp_dt?
		self.receptor_denuncia == RECEPTORES[1]
	end

	def rcp_empresa?
		self.receptor_denuncia == RECEPTORES[0]
	end

	def rcp_externa?
		self.receptor_denuncia == RECEPTORES[2]
	end

	def drv_dt?
		self.no_drvcns? ? nil : self.krn_derivaciones.lst.dstn_dt?
	end

	def drv_empresa?
		self.no_drvcns? ? nil : self.krn_derivaciones.lst.dstn_empresa?
	end

	def drv_externa?
		self.no_drvcns? ? nil : self.krn_derivaciones.lst.dstn_externa?
	end


	# ------------------------------------------------------------------------ PRTCPNTS

	def dnncds?
		self.krn_denunciados.any?
	end

	# ------------------------------------------------------------------------ SGMNT

	# ------------------------------------------------------------------------ DRVCN

	# Se distinguen tres estados, se diferencia si hay o no recepciones
	def derivable?
		(self.drv_empresa? == nil) ? self.rcp_empresa? : self.drv_empresa?
	end

	def recibible?
		self.rcp_externa? and (self.empresa? or self.multiempresa?) and self.no_drvcns?
	end

	# El código verifica si es o no derivable
	# RIOHS Aun no entra en vigencia
	# Esto no cubre el caso multiempresa, en el cual puede haber más de una fecha de activación!
	# ------------------------------------------------------------------------ MDDS DE RESGUARDO

	# ------------------------------------------------------------------------ INVSTGCN

	def investigable?
		self.no_drvcns? ? self.rcp_empresa? : self.drv_empresa?
	end

	def dnnc_ok?
		self.dnnc_incnsstnt? == false and self.dnnc_incmplt? == false
	end

	# ------------------------------------------------------------------------ INVSTGCN




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
