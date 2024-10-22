class Empresa < ApplicationRecord
	has_many :app_nominas, as: :ownr

	has_many :krn_investigadores, as: :ownr
	has_many :krn_denuncias, as: :ownr
	has_many :krn_empresa_externas, as: :ownr
	has_many :krn_tipo_medidas, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true
    validates_uniqueness_of :rut

    def cnt_cntrllr
    	'emprss'
    end

	# OBJETO

    def d_rut
    	self.rut.gsub(' ', '').insert(-8, '.').insert(-5, '.').insert(-2, '-')
    end

end