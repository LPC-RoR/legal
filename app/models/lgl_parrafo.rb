class LglParrafo < ApplicationRecord

	TIPOS = ['Texto', 'Artículo', 'Punto', 'Definición', 'Encabezado', 'Resumen']
	ACCIONES = ['Modificar', 'Agregar', 'Crear']

	belongs_to :lgl_documento

	has_many :lgl_puntos
	has_many :lgl_datos

	# **************************************** PARENT - CHILDREN

	has_one  :parent_relation, :foreign_key => "child_id", :class_name => "LglParraParra"
	has_many :child_relations, :foreign_key => "parent_id", :class_name => "LglParraParra"

	has_one  :parent, :through => :parent_relation
	has_many :children, :through => :child_relations, :source => :child

	scope :ordr, -> { order(:orden) }

	include OrderModel

	def n_parent
		self.parent.blank? ? 0 : self.parent.n_parent + 1
	end

	def chk_ocultar
		self.ocultar ? true : (self.parent.blank? ? false : self.parent.chk_ocultar)
	end

	# ------------------------------------ ORDER LIST

	def list
	self.lgl_documento.lgl_parrafos.ordr
	end

	def redireccion
		self.lgl_documento
	end

	# -----------------------------------------------
end
