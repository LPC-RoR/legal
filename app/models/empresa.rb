class Empresa < ApplicationRecord
	has_many :krn_investigadores
	has_many :krn_denuncias, as: :ownr

	has_one :app_nomina, as: :ownr
end
