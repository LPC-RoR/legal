class AppDocumento < ApplicationRecord

    validates_presence_of :app_documento

	def archivos
		AppArchivo.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def escaneos
		AppEscaneo.where(ownr_class: self.class.name).where(ownr_id: self.id)
	end

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def d_version
		self.archivos.empty? ? nil : self.archivos.order(created_at: :desc).first.archivo
	end

	def control?
		self.documento_control
	end

	def objeto_destino
		['AppDirectorio', 'AppRepositorio'].include?(self.owner_class) ? self.owner.objeto_destino : self.owner
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
