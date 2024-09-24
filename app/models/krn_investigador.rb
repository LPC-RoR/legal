class KrnInvestigador < ApplicationRecord
	belongs_to :cliente, optional: true
	belongs_to :empresa, optional: true

	has_many :krn_denuncias
	has_many :krn_declaraciones

	scope :rut_ordr, -> { order(:rut) }
end
