class KrnDerivacion < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true

	scope :ordr, -> { order(:created_at) }

	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true

	def self.lst
		ordr.last
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