class Procedimiento < ApplicationRecord
	belongs_to :tipo_procedimiento

	has_many :ctr_etapas
	has_many :rep_doc_controlados, as: :ownr
	has_many :lgl_temas, as: :ownr

	has_many :pdf_archivos, as: :ownr

	has_many :productos

	scope :lst, -> {order(:procedimiento)}

	def self.lista
		Procedimiento.lst.map {|proc| proc.procedimiento}
	end

	def self.prcdmnt(cdg)
		find_by(codigo: cdg)
	end

	def ok?
		self.ctr_etapas.ordr.last.ok?
	end
end
