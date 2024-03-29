module Tablas
	extend ActiveSupport::Concern

	def menu_tablas
		[
			#['Título', 'partial', indent, despliegue]
			['General', nil, 1, true],
			['UF & Regiones', 'uf_regiones', 2, true],
			['Enlaces', 'enlaces', 2, true],
			['Calendario', 'calendario', 2, true],
			['Agenda', 'agenda', 2, true],
			['Causas & asesorías', nil, 1, true],
			['Tipos', 'tipos_causas_asesorias', 2, true],
			['Cuantías & Tribunales', 'cuantias_tribunales', 2, true],
			['Tarifas generales', 'tarifas_generales', 2, true],
			['Modelo de Negocios', nil, 1, true],
			['Modelo', 'modelo', 2, true],
			['Periodos & Bancos', 'secundarias_modelo', 2, true],
		]
	end

	def tb_index(clave)
		menu_tablas.map {|e| e[1]}.index(clave)
	end

	def tb_item(indice)
		menu_tablas[indice][0]
	end

	def first_tabla_index
		tb_index(menu_tablas.map {|e| e[1]}.compact.first)
	end

end