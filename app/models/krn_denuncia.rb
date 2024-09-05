class KrnDenuncia < ApplicationRecord
	belongs_to :cliente, optional: true
	belongs_to :motivo_denuncia
	belongs_to :receptor_denuncia

	has_many :rep_archivos, as: :ownr

	has_many :krn_denunciantes
	has_many :krn_denunciados

	scope :ordr, -> { order(fecha_hora: :desc) }

	# Ids de las empresas externas. nil => Empresa principal
	# No hemos resuelto manejo de subcontratos y ASTs
	def emprss_ids
		( self.krn_denunciantes.emprss_ids + self.krn_denunciados.emprss_ids ).uniq
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnDenuncia').rep_doc_controlados.ordr
	end

	def invstgdr_dt?
		self.receptor_denuncia.receptor_denuncia == 'Dirección del Trabajo'
	end

	def por_representante?
		self.presentado_por == 'Representante'
	end

	def entdd_invstgdr
		ids = self.emprss_ids
		self.invstgdr_dt? ? 'Dirección del Trabajo' : ( ids.length == 1 ? ( ids.first.blank? ? 'Empresa' : 'Empresa externa' ) : 'Empresa' )
	end

	def owner
#		self.cliente_id.blank? ? self.empresa : self.cliente
		self.cliente
	end

end
