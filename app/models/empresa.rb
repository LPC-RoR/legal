class Empresa < ApplicationRecord
	has_many :app_nominas, as: :ownr

	has_many :pro_dtll_ventas, as: :ownr

	has_many :krn_investigadores, as: :ownr
	has_many :krn_denuncias, as: :ownr
	has_many :krn_empresa_externas, as: :ownr

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

    def krn?
    	self.pro_dtll_ventas.map {|dv| dv.producto.codigo.split('_')[0]}.include?('krn')
    end

    def krn_formato
    	self.pro_dtll_ventas.map {|dv| dv.producto.formato if dv.producto.present?}.last
    end

end