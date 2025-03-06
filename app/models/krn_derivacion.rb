class KrnDerivacion < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true

	scope :ordr, -> { order(:created_at) }

	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true

	def self.lst
		ordr.last
	end

	def self.rcpcn_extrn?
		where(codigo: 'rcpcn_extrn').any?
	end

	def self.rcpcn_dt?
		where(codigo: 'rcpcn_dt').any?
	end

	def self.drvcn_art4_1?
		where(codigo: 'drvcn_art4_1').any?
	end

	def self.drvcn_dnncnt?
		where(codigo: 'drvcn_dnncnt').any?
	end

	def self.drvcn_emprs?
		where(codigo: 'drvcn_emprs').any?
	end

	def self.drvcn_ext?
		where(codigo: 'drvcn_ext').any?
	end
	def self.drvcn_ext_dt?
		where(codigo: 'drvcn_ext_dt').any?
	end
	# --------------------------------------------------------

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