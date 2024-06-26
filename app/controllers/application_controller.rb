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
	helper_method :params_to_date, :dt_hoy, :s_hoy
	helper_method :calcula2, :set_formulas, :set_valores, :set_detalle_cuantia, :vlr_cuantia, :chck_cuantia, :vlr_tarifa, :chck_tarifa, :total_cuantia 
	helper_method :pgs_stts, :fecha_calculo, :leyenda_origen_fecha_calculo, :uf_calculo, :v_monto_calculo, :get_tar_uf_facturacion, :get_tar_facturacion, :monto_pesos, :monto_uf
	helper_method :modelo_negocios_general, :cuentas_corrientes, :periodos
	helper_method :nombre_dia, :nombre3_dia, :load_calendario, :get_cal_dia, :dyf, :prfx_dia
	helper_method :check_tipo_usuario, :lm_check_tipo_usuario, :check_crud, :check_k_estados, :check_st_estado
	helper_method :cfg_defaults, :cfg_navbar, :cfg_color, :cfg_fonts
	helper_method :cmenu_clss, :first_estado, :first_selector, :display_name

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

end
