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
		'orden',
		'nivel',
		'elemento',
		'tipo',
		'despliegue'
	]

    validates_presence_of :tipo, :elemento
end
