class KrnDerivacion < ApplicationRecord
	belongs_to :krn_denuncia

	scope :ordr, -> { order(:created_at) }

	def self.lst
		ordr.last
	end

	def dstn_dt?
		self.tipo == 'Derivación' and self.krn_empresa_externa_id.blank?
	end

	def dstn_empresa?
		self.tipo == 'Recepción' and self.krn_empresa_externa_id.blank?
	end

	def dstn_externa?
		self.tipo == 'Derivación' and self.krn_empresa_externa_id.present?
	end

	def dstn
		self.dstn_dt? ? 'Dirección del Trabajo' : ( self.dstn_empresa? ? 'Empresa' : 'Empresa externa' )
	end

end