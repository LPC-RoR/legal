class AppNomina < ApplicationRecord

	TABLA_FIELDS = [
		['nombre', 'normal'],
		['email',  'show']
	]

	has_many :st_perfil_modelos

	def tar_bases
		TarBase.where(owner_class: 'AppNomina', owner_id: self.id)
	end

	def tar_variables
		TarVariable.where(owner_class: 'AppNomina', owner_id: self.id)
	end

	validates :email, presence: true
	validates :email, uniqueness: true

end
