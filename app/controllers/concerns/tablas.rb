module Tablas
	extend ActiveSupport::Concern

	def menu_tablas
		[
			#['Título', 'partial', indent, despliegue]
			['General', 'general', 1, true],
			['Causas & asesorías', nil, 1, true],
			['Tarifas generales', 'tarifas_generales', 2, true],
			['Tablas secundarias', 'tablas_secundarias', 2, true],
			['Modelo de Negocios', nil, 1, true],
			['Modelo', 'modelo', 2, true],
			['Tablas secundarias', 'secundarias_modelo', 2, true],
		]
	end

	def tb_index(clave)
		menu_tablas.map {|e| e[1]}.index(clave)
	end

	def first_tabla_index
		tb_index(menu_tablas.map {|e| e[1]}.compact.first)
	end

end