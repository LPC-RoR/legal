class ControlDocumento < ApplicationRecord
	TIPOS = ['Documento', 'Archivo']
	CONTROLES = ['Requerido', 'Opcional']

	belongs_to :ownr, polymorphic: true

	def self.nms
		all.map {|cd| cd.nombre}		
	end

	def self.acs
		where(tipo: 'Archivo').order(:orden)
	end

	def self.dcs
		where(tipo: 'Documento').order(:orden)
	end

  def req?
    self.control == CONTROLES[0]
  end

	# ------------------------------------ ORDER LIST

	def list
		self.ownr.control_documentos.order(:orden)
	end

	def n_list
		self.list.count
	end

	def siguiente
		self.list.find_by(orden: self.orden + 1)
	end

	def anterior
		self.list.find_by(orden: self.orden - 1)
	end

	def redireccion
		case self.ownr_class
		when 'TarDetalleCuantia'
			"/tablas?tb=7"
		when 'StModelo'
			"/st_modelos"
		end
	end

	# -----------------------------------------------
end
