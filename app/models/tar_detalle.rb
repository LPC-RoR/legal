class TarDetalle < ApplicationRecord
	# Tabla de DETALLE DE TARIFAS
	# son Expresiones unitarias de fórmulas

	TIPOS = ['valor', 'suma', 'producto', 'condicional', 'piso_tope', 'ahorro', 'máximo', 'otros', 'pesos', 'uf']

	TABLA_FIELDS = [
		'orden',
		'codigo',
		'detalle',
		'tipo',
		'formula'
	]

	belongs_to :tar_tarifa
end
