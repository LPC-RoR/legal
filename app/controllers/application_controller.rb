class ApplicationController < ActionController::Base

	include Inicia
	include IniciaAplicacion

	include Capitan

	include Seguridad

	include Map	

	include Tarifas

	before_action :init_bandejas, only: %i[ new edit show index create tablas update]

	helper_method :dog?, :admin?, :nomina?, :general?, :anonimo?, :seguridad_desde, :dog_email, :dog_name, :perfil?, :perfil_activo, :perfil_activo_id, :mi_seguridad?
	helper_method :bandeja_display?
	helper_method :uf_del_dia, :uf_fecha
	helper_method :calcula, :eval_condicion, :eval_elemento

	# ************************************************************************** COLECCINES DE ESTADOS
 
 	def st_colecciones(modelo, estado)
		case modelo
		when 'Causa'
			modelo.constantize.where(estado: estado).order(fecha_ingreso: :desc)
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
