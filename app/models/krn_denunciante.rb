class KrnDenunciante < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :krn_lst_medidas, as: :ownr
	has_many :krn_lst_modificaciones, as: :ownr

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id}
	end

	def self.ordr
		order(:rut)
	end

	def empleador
		self.krn_empresa_externa_id.blank? ? 'Empleado de la empresa' : self.krn_empresa_externa.krn_empresa_externa
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnDenunciante').rep_doc_controlados.ordr
	end

end
