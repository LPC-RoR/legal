module Tablas
	extend ActiveSupport::Concern

	def menu_tablas
		[
			#['Título', 'partial', indent, despliegue]
			['General',               nil,                      1, 'general'],
			['UF & Regiones',         'uf_regiones',            2, 'general'],
			['Enlaces',               'enlaces',                2, 'general'],
			['Calendario',            'calendario',             2, 'operación'],
			['Agenda',                'agenda',                 2, 'general'],
			['Causas & asesorías',    nil,                      1, 'operación'],
			['Tipos',                 'tipos_causas_asesorias', 2, 'operación'],
			['Cuantías & Tribunales', 'cuantias_tribunales',    2, 'operación'],
			['Tarifas generales',     'tarifas_generales',      2, 'finanzas'],
			['Modelo de Negocios',    nil,                      1, 'finanzas'],
			['Modelo',                'modelo',                 2, 'finanzas'],
			['Periodos & Bancos',     'secundarias_modelo',     2, 'finanzas'],
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