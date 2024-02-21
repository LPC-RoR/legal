class AppVersion < ApplicationRecord
	DOG_EMAIL = 'hugo.chinga.g@gmail.com'
	DOG_NAME = 'Hugo Chinga G.'

	def dog_perfil
		AppPerfil.where(o_clss: self.class.name, o_id: self.id).first
	end
end
