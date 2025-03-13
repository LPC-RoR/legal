class KrnDenuncia < ApplicationRecord

	DT = 'Dirección del Trabajo'

	ACCTN = 'dnncs'

	MOTIVOS = ['Acoso laboral', 'Acoso sexual', 'Violencia en el trabajo ejercida por terceros']

	VIAS_DENUNCIA = ['Presencial', 'Correo electrónico', 'Plataforma']
	TIPOS_DENUNCIANTE = ['Denunciante', 'Representante']
	TIPOS_DENUNCIA = ['Escrita', 'Verbal']

	PROC = 'krn_invstgcn'

	belongs_to :ownr, polymorphic: true

	belongs_to :krn_empresa_externa, optional: true
#	belongs_to :krn_investigador, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :valores, as: :ownr

	has_many :ctr_registros, as: :ownr

	has_many :krn_denunciantes
	has_many :krn_denunciados
	has_many :krn_derivaciones
	has_many :krn_declaraciones

	has_many :krn_inv_denuncias
	has_many :krn_investigadores, through: :krn_inv_denuncias

	scope :ordr, -> { order(fecha_hora: :desc, id: :desc) }

	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true
	delegate :razon_social, to: :ownr, prefix: true, allow_nil: true

    validates_presence_of :fecha_hora

	include Valores
	include DnncVlrs
	include Dnnc
	include DnncProc
	include Procs

	delegate :krn_formato, to: :ownr, prefix: true

	def dnnc
		self
	end

	# ------------------------------------------------------------------------ PRODUCTO
	# Determina si el ownr de la denuncia tiene contratado un formato P+
	def p_plus?
		self.ownr_krn_formato == 'P+'
	end

	def lttr_tp
		self.multiempresa? ? 'Multi' : (self.externa? ? 'Externa' : (self.empresa? ? 'Empresa' : '?'))
	end

	# ------------------------------------------------------------------------

	def rlzds?
 		self.krn_denunciantes.rlzds? and self.krn_denunciados.rlzds?
	end

	# ------------------------------------------------------------------------ REP ARCHIVOS

	# Archivos existentes de un documento controlado multiple
	def fls(dc)
		self.rep_archivos.where(rep_doc_controlado_id: dc.id).crtd_ordr
	end

	# Archivos existentes de un documento controlado simple
	def fl(dc)
		self.fls(dc).last
	end

	def fl?(code)
		dc = RepDocControlado.get_dc(code)
		fl(dc).present?
	end

	# ------------------------------------------------------------------------ COMPETENCIA DE INVESTIGAR
	# Se conservó la forma inicial

	def emprss_ids
		( self.krn_denunciantes.emprss_ids + self.krn_denunciados.emprss_ids ).uniq
	end

	def empresa?
		e_ids = self.emprss_ids
		e_ids.length == 1 and e_ids[0] == nil
	end

	def externa?
		e_ids = self.emprss_ids
		e_ids.length == 1 and e_ids[0] != nil
	end

	def multiempresa?
		e_ids = self.emprss_ids
		self.emprss_ids.length > 1
	end

	# externa que investiga REVISAR porque se puede confundir con Externa que recibió
	def empleador
		ids = self.emprss_ids
		self.externa? ? KrnEmpresaExterna.find(ids[0]) : nil
	end

	# ------------------------------------------------------------------------ RCPS & DRVS

	def rcp_dt?
		self.receptor_denuncia == KrnDenuncia::DT
	end

	def rcp_empresa?
		self.receptor_denuncia == 'Empresa'
	end

	def rcp_externa?
		self.receptor_denuncia == 'Empresa externa'
	end

	# Alguna vez fue derivada a la DT
	def drv_dt?
		self.krn_derivaciones.any? ? false : self.krn_derivaciones.dts.any?
	end

	def on_dt?
		self.krn_derivaciones.empty? ? self.rcp_dt? : self.krn_derivaciones.on_dt?
	end

	def on_empresa?
		self.krn_derivaciones.empty? ? self.rcp_empresa? : self.krn_derivaciones.on_empresa?
	end

	def on_externa?
		self.krn_derivaciones.empty? ? self.rcp_externa? : self.krn_derivaciones.on_externa?
	end

	# ---------------------------------------------------------------------- SCOPE FIELDS

	def frst_invstgdr
		self.krn_investigadores.first
	end

	def scnd_invstgdr
		self.krn_investigadores.first
	end

end
