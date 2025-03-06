class KrnDenuncia < ApplicationRecord

	ACCTN = 'dnncs'

	MOTIVOS = ['Acoso laboral', 'Acoso sexual', 'Violencia en el trabajo ejercida por terceros']

	VIAS_DENUNCIA = ['Presencial', 'Correo electrónico', 'Plataforma']
	TIPOS_DENUNCIANTE = ['Denunciante', 'Representante']
	TIPOS_DENUNCIA = ['Escrita', 'Verbal']

	PROC = 'krn_invstgcn'
	PROC_INIT = ['ownr', 'fecha_hora', 'motivo', 'receptor', 'canal', 'presentado_por']

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

    validates_presence_of :fecha_hora

	include Valores
	include DnncVlrs
	include Dnnc
	include DnncProc
	include Procs

	delegate :krn_formato, to: :ownr, prefix: true

	def p_plus?
		self.ownr_krn_formato == 'P+'
	end

	def fls(dc)
		self.rep_archivos.where(rep_doc_controlado_id: dc.id).crtd_ordr
	end

	def fl(dc)
		self.fls(dc).last
	end

	# ------------------------------------------------------------------------ PROC

	def ownr_razon_social
		self.ownr.razon_social
	end

	def rcptr_externa
		self.krn_empresa_externa.razon_social
	end

	# ------------------------------------------------------------------------ COMPETENCIA DE INVESTIGAR

	def emprss_ids
		( self.krn_denunciantes.emprss_ids + self.krn_denunciados.emprss_ids ).uniq
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

	def lttr_tp
		self.multiempresa? ? 'M' : (self.externa? ? 'X' : (self.empresa? ? 'E' : '?'))
	end

	def externa
		ids = self.emprss_ids
		self.externa? ? KrnEmpresaExterna.find(ids[0]) : nil
	end

	# ------------------------------------------------------------------------ RCPS & DRVS

	def rcp_dt?
		self.receptor_denuncia == 'Dirección del Trabajo'
	end

	def rcp_empresa?
		self.receptor_denuncia == 'Empresa'
	end

	def rcp_externa?
		self.receptor_denuncia == 'Empresa externa'
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

	def on_empresa?
		self.no_drvcns? ? self.rcp_empresa? : self.drv_empresa?
	end

	def on_externa?
		self.no_drvcns? ? self.rcp_externa? : self.drv_externa?
	end

	def on_dt?
		self.no_drvcns? ? self.rcp_dt? : self.drv_dt?
	end

	def invstgcn_emprs?
		self.vlr_drv_emprs_optn?
	end


	# --------------------------------------------------------------------------------------------- DOCUMENTOS CONTROLADOS

	def dc_denuncia
		RepDocControlado.find_by(codigo: 'dnnc_denuncia')
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
