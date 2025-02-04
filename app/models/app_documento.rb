class AppDocumento < ApplicationRecord

	belongs_to :ownr, polymorphic: true

    validates_presence_of :app_documento

	# Nombres
	def self.nms
		all.map {|dcmnt| dcmnt.app_documento}		
	end

	# REVISAR posiblemente DEPRECATED

	def archivos
		AppArchivo.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def escaneos
		AppEscaneo.where(ownr_class: self.class.name).where(ownr_id: self.id)
	end

	def d_version
		self.archivos.empty? ? nil : self.archivos.order(created_at: :desc).first.archivo
	end

	def control?
		self.documento_control
	end

	def objeto_destino
		['AppDirectorio', 'AppRepositorio'].include?(self.owner_class) ? self.ownr.objeto_destino : self.ownr
	end

	def control_documento
		AppControlDocumento.find_by(app_control_documento: self.referencia)
	end

	def doc_vencimiento
		self.control_documento.blank? ? self.vencimiento : self.control_documento.vencimiento
	end

	def doc_existencia
		self.control_documento.blank? ? self.existencia : self.control_documento.existencia
	end

	def flag_existencia
		self.doc_existencia == 'obligatorio' and self.escaneos.any?
	end

	def flag_vencimiento
		# pendiente de agregar parámetro vencimiento
		self.esceneos.order(created_at: :desc).first
	end

end
