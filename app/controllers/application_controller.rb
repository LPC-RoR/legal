class ApplicationController < ActionController::Base

	include Config
	include Seguridad

	include Inicia
	include IniciaAplicacion

	include Capitan
	include Tablas
	include Cmenu


	include Modelos

	include Calendario

	include Tarifas

	# Seguridad
	helper_method :version_activa, :nomina_activa, :perfil_activo?, :perfil_activo, :nomina?
	helper_method :dog_name, :dog_email, :dog?, :admin?, :usuario?, :publico?, :seguridad, :public_controllers 
	helper_method :check_tipo_usuario, :operacion?, :finanzas?
	helper_method :uf_del_dia, :uf_fecha, :enlaces_general, :v_enlaces_general, :enlaces_perfil, :v_enlaces_perfil, :v_enlaces, :set_st_estado, :object_class_sym
	helper_method :calcula2, :set_formulas, :set_valores, :set_detalle_cuantia
	helper_method :modelo_negocios_general, :cuentas_corrientes, :periodos
	helper_method :nombre_dia, :nombre3_dia, :load_calendario
	helper_method :check_tipo_usuario, :lm_check_tipo_usuario, :check_crud, :check_k_estados, :check_st_estado
	helper_method :cfg_defaults, :cfg_navbar, :cfg_color, :cfg_fonts
	helper_method :cmenu_clss, :first_estado, :first_selector

	# ************************************************************************** COLECCINES DE ESTADOS
 
 	def st_colecciones(modelo, estado)
		case modelo
		when 'Causa'
			modelo.constantize.where(estado: estado).order(created_at: :desc)
		when 'Cliente'
			modelo.constantize.where(estado: estado).order(:razon_social)
		when 'Consultoria'
			modelo.constantize.where(estado: estado).order(created_at: :desc)
		when 'TarFactura'
			modelo.constantize.where(estado: estado).order(documento: :desc)
		end
	end

	# Este método se usa para construir un nombre de directorio a partir de un correo electrónico.
	def archivo_usuario(email, params)
		email.split('@').join('-').split('.').join('_')
	end

	def number? string
	  true if Float(string) rescue false
	end

	def params_to_date(prms, date_field)
		DateTime.new(prms["#{date_field}(1i)"].to_i, prms["#{date_field}(2i)"].to_i, prms["#{date_field}(3i)"].to_i, 0, 0, 0, "#{Time.zone.utc_offset/3600}")
	end

end
