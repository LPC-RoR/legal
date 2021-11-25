class AppDirectorio < ApplicationRecord

	TABLA_FIELDS = [
		['directorio', 'show'], 
	]

#	has_many :app_archivos
#	has_many :app_imagenes

	has_one  :parent_relation, :foreign_key => "child_id", :class_name => "AppDirDir"
	has_many :child_relations, :foreign_key => "parent_id", :class_name => "AppDirDir"

	has_one  :parent, :through => :parent_relation
	has_many :children, :through => :child_relations, :source => :child

	def documentos
		AppDocumento.where(owner_class: 'AppDirectorio').where(owner_id: self.id)
	end

	def archivos
		AppArchivo.where(owner_class: 'AppDirectorio').where(owner_id: self.id)
	end

	def padre
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

end
