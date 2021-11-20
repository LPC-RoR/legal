class TarDetalle < ApplicationRecord

	TIPOS = ['valor', 'suma', 'producto', 'condicional', 'piso_tope', 'ahorro', 'máximo', 'otros']

	TABLA_FIELDS = [
		['orden',   'normal'],
		['codigo',  'normal'],
		['detalle', 'show'],
		['tipo',    'normal'],
		['formula', 'normal']
	]

	belongs_to :tar_tarifa
end
