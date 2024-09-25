class AppVersion < ApplicationRecord
	DOG_EMAIL = 'hugo.chinga.g@gmail.com'
	DOG_NAME = 'Hugo Chinga G.'

	has_one :app_nomina, as: :ownr

	has_many :cfg_valores

	def dog_perfil
		AppPerfil.where(o_clss: self.class.name, o_id: self.id).first
	end
end
