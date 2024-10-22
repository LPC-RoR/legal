class KrnInvestigador < ApplicationRecord

	ACCTN = 'invstgdrs'

	belongs_to :ownr, polymorphic: true

	has_many :krn_denuncias
	has_many :krn_declaraciones

	scope :rut_ordr, -> { order(:rut) }

	validates :rut, valida_rut: true
    validates_presence_of :rut, :krn_investigador, :email
end
