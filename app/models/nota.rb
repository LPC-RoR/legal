class Nota < ApplicationRecord

	belongs_to :ownr, polymorphic: true
	belongs_to :app_perfil

	has_many :age_usu_notas
	has_many :age_usuarios, through: :age_usu_notas

	scope :no_rlzds, -> { where(realizado: [false, nil]) }
	scope :rlzds, -> { where(realizado: true) }

end
