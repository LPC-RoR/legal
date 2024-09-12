class KrnInvestigador < ApplicationRecord
	has_many :krn_denuncias
	has_many :krn_declaraciones

	scope :ordr, -> { order(:rut) }
end
