class KrnDenunciado < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empleado, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :krn_lst_medidas, as: :ownr

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id}
	end

	def self.ordr
		order(:rut)
	end

	def empleador
		self.krn_empresa_externa_id.blank? ? 'Empleado de la empresa' : self.krn_empresa_externa.krn_empresa_externa
	end

end
