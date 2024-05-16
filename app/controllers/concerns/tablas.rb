module Tablas
	extend ActiveSupport::Concern

	# ************************************ MANEJO DE PATHS

	def sym_objeto(objeto)
		objeto.class.name.tableize.to_sym
	end

	def crud_partial
		{
			tar_uf_sistemas: 'uf_regiones',
			regiones: 'uf_regiones',
			app_enlaces: 'enlaces',
			cal_feriados: 'calendario',
			age_usuarios: 'agenda',
			tipo_causas: 'tipos',
			tipo_asesorias: 'tipos',
			audiencias: 'tipos',
			tar_detalle_cuantias: 'cuantias_tribunales',
			tribunal_cortes: 'cuantias_tribunales',
			tar_tarifas: 'tarifas_generales',
			tar_servicios: 'tarifas_generales',
			m_conceptos: 'modelo',
			m_items: 'modelo',
			m_cuentas: 'modelo',
			m_bancos: 'periodos_bancos'
		}
	end

	def tabla_path(objeto)
		"/tablas/#{crud_partial[sym_objeto(objeto)]}"
	end

end