class KrnInvestigador < ApplicationRecord
	has_many :krn_denuncias

	scope :ordr, -> { order(:rut) }
end
