class LglParrafo < ApplicationRecord
	belongs_to :lgl_documento

	has_many :lgl_datos

	# **************************************** PARENT - CHILDREN

	has_one  :parent_relation, :foreign_key => "child_id", :class_name => "LglParraParra"
	has_many :child_relations, :foreign_key => "parent_id", :class_name => "LglParraParra"

	has_one  :parent, :through => :parent_relation
	has_many :children, :through => :child_relations, :source => :child

	def n_parent
		self.parent.blank? ? 0 : self.parent.n_parent + 1
	end

	# ------------------------------------ ORDER LIST

	def owner
		self.lgl_documento
	end

	def list
		self.owner.lgl_parrafos.order(:orden)
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
		"/tablas?tb=1"
	end

	# -----------------------------------------------
end
