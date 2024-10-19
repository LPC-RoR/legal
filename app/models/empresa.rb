class Empresa < ApplicationRecord
	has_many :krn_investigadores
	has_many :krn_denuncias, as: :ownr

	has_one :app_nomina, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true
    validates_uniqueness_of :rut
end
