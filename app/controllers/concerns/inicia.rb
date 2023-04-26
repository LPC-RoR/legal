module Inicia
	extend ActiveSupport::Concern

	def verifica_primer_acceso
		if ActiveRecord::Base.connection.table_exists? 'app_administradores'
			@dog = AppAdministrador.find_by(email: dog_email)
			@dog = AppAdministrador.create(administrador: dog_name, email: dog_email) if @dog.blank?
		else
			@dog = Administrador.find_by(email: dog_email)
			@dog = Administrador.create(administrador: dog_name, email: dog_email) if @dog.blank?
		end

	end

	def inicia_sesion

		# se hace para no llamar a cada rato a la base de datos
		perfil = perfil_activo

		# si hay USUARIO AUTENTICADO pero el usuario NO TIENE PERFIL}
		# ocurre si es el primer acceso a la aplicación o si el usuario recién se creo
		if usuario_signed_in? and perfil.blank?

			# INICIALIZA VARIBLES EN PRIMER ACCESO
			verifica_primer_acceso

			# crea perfil si está en archivo de administradores o en nómina o aplicación es de libre registro
			administrador = AppAdministrador.find_by(email: current_usuario.email)
			nomina = AppNomina.find_by(email: current_usuario.email)

			if nomina.present? or administrador.present? or libre_registro?
				perfil = AppPerfil.create(email: current_usuario.email)
			end

		end

		# lo puse aqui porque dog ya estaba creado
		set_tablas_base if SbLista.all.empty?

		# si hay perfil_activo ? hay usuarios se inicia applicacion : se despliega home SIN perfil_activo
		inicia_app if perfil.present?

	end

end