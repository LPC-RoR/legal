class KrnDerivacion < ApplicationRecord

	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true

	has_many :pdf_registros, as: :ref

	scope :ordr, -> { order(:created_at) }

	scope :dts, -> { where(destino: KrnDenuncia::DT) }

	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true

	def dnnc
		self.krn_denuncia
	end

	def dflt_bck_rdrccn
		"/krn_denuncias/#{self.dnnc.id}_1"
	end

	def self.lst
		ordr.last
	end

	# --------------------------------------------------------

	def self.on_dt?
		all.empty? ? false : all.ordr.last.destino == KrnDenuncia::DT
	end

	def self.on_empresa?
		all.empty? ? false : all.ordr.last.destino == 'Empresa'
	end

	def self.on_externa?
		all.empty? ? false : all.ordr.last.destino == 'Externa'
	end

	def dstn_dt?
		self.destino == 'Dirección del Trabajo'
	end

	def dstn_empresa?
		self.destino == 'Empresa'
	end

	def dstn_externa?
		self.destino == 'Externa'
	end

	def dstn
		self.dstn_dt? ? 'Dirección del Trabajo' : ( self.dstn_empresa? ? 'Empresa' : 'Empresa externa' )
	end

end