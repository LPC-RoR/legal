class StModelo < ApplicationRecord

	has_many :st_estados

    validates_presence_of :st_modelo

    def self.get_model(modelo)
    	find_by(st_modelo: modelo)
    end

	def primer_estado
		self.st_estados.empty? ? nil : self.estados.first
	end

	def modelo
		self.st_modelo
	end

	def estados
		self.st_estados.ordr_stts
	end

	def stts_arry
		self.estados.map {|stt| stt.st_estado}
	end

	def control_documentos
		ControlDocumento.where(owner_class: self.class.name, owner_id: self.id).order(:orden)
	end

end
