class AgeUsuario < ApplicationRecord

	belongs_to :app_perfil

	has_many :age_usu_acts
	has_many :age_actividades, through: :age_usu_acts

	has_many :age_usu_notas
	has_many :notas, through: :age_usu_notas

	has_many :age_pendientes

	validates :age_usuario, presence: true
	validates :age_usuario, uniqueness: true

	scope :no_ownr, -> { where(owner_class: nil, owner_id: nil) }

end
