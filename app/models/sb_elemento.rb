class SbElemento < ApplicationRecord

	belongs_to :sb_lista

	TIPOS = ['item', 'list']
	ACCESOS = ['nomina', 'admin', 'anonimo', 'dog']
	DESPLIEGUES = ['show', 'list', 'ayuda', 'ulist']

	DISPLAY_FIELDS = [
		['orden',       'Orden',            'number'],
		['nivel',       'Nivel',            'number'],
		['tipo',        'Tipo Elemento',    'string'],
		['acceso',      'Acceso',           'string'],
		['despliegue',  'Despliegue',       'string'],
		['controlador', 'Controlador',      'string'],
		['activo',      'Elemento Activo?', 'boolean']
	]

	TABLA_FIELDS = [
		'nivel',
		'elemento',
		'tipo',
		'despliegue'
	]

    validates_presence_of :tipo, :elemento

	# ------------------------------------ ORDER LIST

	def owner
		self.sb_lista
	end

	def list
		self.sb_lista.sb_elementos.order(:orden)
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
		"/sb_listas/#{self.owner.id}"
	end

	# -----------------------------------------------

end
