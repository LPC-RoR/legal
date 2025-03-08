class AppDirectorio < ApplicationRecord

    validates_presence_of :app_directorio

	has_one  :parent_relation, :foreign_key => "child_id", :class_name => "AppDirDir"
	has_many :child_relations, :foreign_key => "parent_id", :class_name => "AppDirDir"

	has_one  :parent, :through => :parent_relation
	has_many :children, :through => :child_relations, :source => :child

	def documentos
		AppDocumento.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def directorios
		AppDirectorio.where(owner_class: self.class.name, owner_id: self.id)
	end

	def archivos
		AppArchivo.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def owner
		self.parent.present? ? self.parent : self.owner_class.constantize.find(self.owner_id)
	end

	def padres_ids
		ids = []
		objeto = self
		while objeto.present? do
			ids << objeto.parent.id unless objeto.parent.blank?
			objeto = objeto.parent	
		end
		ids.reverse
	end

	def existe_documento?(documento)
		not self.documentos.find_by(app_documento: documento).blank?
	end

	def control?
		self.directorio_control
	end

	def objeto_destino
		['AppDirectorio', 'AppRepositorio'].include?(self.owner_class) ? self.owner.objeto_destino : self.owner
	end

end
