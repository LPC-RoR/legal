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
	include Plazos

	include Tarifas

	# Seguridad tabla_path
	helper_method :get_public_controllers, :get_version_activa, :get_perfil_activo, :get_app_sigla
	helper_method :scp_err?, :scp_activo?, :dog_perfil, :dog_perfil?, :tipo_usuario, :version_activa, :version_activa?, :nomina_activa, :nomina_activa?, :perfil_activo, :perfil_activo?, :usuario_agenda, :usuario_agenda?
	helper_method :dog_name, :dog_email, :dog?, :admin?, :usuario_activo?, :publico?, :seguridad, :public_controllers 
	helper_method :operacion?, :finanzas?
	helper_method :uf_del_dia, :uf_fecha, :enlaces_general, :v_enlaces_general, :enlaces_perfil, :v_enlaces_perfil, :v_enlaces, :set_st_estado, :object_class_sym
	helper_method :arriba, :abajo, :reordenar
	helper_method :params_to_date, :dt_hoy, :s_hoy
	helper_method :swtch_urgencia, :swtch_pendiente, :swtch_prrdd
	helper_method :calcula2, :set_formulas, :vlr_cuantia, :chck_cuantia, :vlr_tarifa, :chck_tarifa, :get_total_cuantia 
	helper_method :pgs_stts, :get_fecha_calculo, :leyenda_origen_fecha_calculo, :get_uf_calculo, :get_v_calculo_tarifa, :requiere_uf, :get_tar_uf_facturacion, :get_tar_facturacion, :get_monto_calculo_pesos, :get_monto_calculo_uf
	helper_method :modelo_negocios_general, :cuentas_corrientes, :periodos
	helper_method :nombre_dia, :nombre3_dia, :load_calendario, :get_cal_dia, :dyf, :prfx_dia
	helper_method :itm_scrty, :lm_seguridad, :check_crud, :check_k_estados, :check_st_estado
	helper_method :cfg_defaults, :cfg_navbar, :cfg_color, :cfg_fonts
	helper_method :cmenu_clss, :std, :typ, :display_name, :scp_menu, :scp_item
	helper_method :plz_lv, :plz_c
	helper_method :krn_fl_cntrl, :krn_cntrllrs?

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
