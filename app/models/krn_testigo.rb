class KrnTestigo < ApplicationRecord
 	belongs_to :ownr, polymorphic: true
	belongs_to :krn_empresa_externa, optional: true

	has_many :krn_declaraciones, as: :ownr
	has_many :rep_archivos, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true
    validates_presence_of :rut, :nombre, :cargo, :lugar_trabajo
    validates_presence_of :email, if: -> {[nil, false].include?(articulo_516)}

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
