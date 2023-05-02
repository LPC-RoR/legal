class ApplicationController < ActionController::Base

	include Inicia
	include IniciaAplicacion

	include Capitan

	include Seguridad

	include Map	

	before_action :init_bandejas, only: %i[ new edit show index create tablas]

	helper_method :dog?, :admin?, :nomina?, :general?, :anonimo?, :seguridad_desde, :dog_email, :dog_name, :perfil?, :perfil_activo, :perfil_activo_id, :mi_seguridad?
	helper_method :bandeja_display?
	helper_method :uf_del_dia

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
