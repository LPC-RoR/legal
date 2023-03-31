class AppNomina < ApplicationRecord

	TABLA_FIELDS = [
		'nombre',
		's#email',
		'perfil'
	]

	has_many :st_perfil_modelos

	validates :nombre, :email, presence: true
	validates :nombre, :email, uniqueness: true

	def tar_bases
		TarBase.where(owner_class: 'AppNomina', owner_id: self.id)
	end

	def tar_variables
		TarVariable.where(owner_class: 'AppNomina', owner_id: self.id)
	end

	def perfil
		perfil = AppPerfil.find_by(email: self.email)
		perfil.blank? ? 'Sin perfil' : 'Perfil activo'
	end

end
