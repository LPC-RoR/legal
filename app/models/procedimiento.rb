class Procedimiento < ApplicationRecord
	belongs_to :tipo_procedimiento

	has_many :ctr_etapas

	def self.prcdmnt(cdg)
		find_by(codigo: cdg)
	end

	def ok?
		self.ctr_etapas.ordr.last.ok?
	end
end
