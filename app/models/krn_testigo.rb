class KrnTestigo < ApplicationRecord
 	belongs_to :ownr, polymorphic: true

	has_many :krn_declaraciones, as: :ownr
	has_many :rep_archivos, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	def css_id
		"tstg#{self.id}"
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnTestigo').rep_doc_controlados.ordr
	end

	def denuncia
		self.ownr.denuncia
	end
end
