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
    	if self.pro_dtll_ventas.empty?
    		self.demo == 'Estandar' ? 'P' : 'P+'
    	else
    		self.pro_dtll_ventas.map {|dv| dv.producto.formato if dv.producto.present?}.last
    	end
    end

    def demo?
    	self.pro_dtll_ventas.empty?
    end

    def init?
    	self.krn_denuncias.empty? and self.krn_empresa_externas.empty? and self.krn_investigadores.empty?
    end

    def no_externas?
    	self.krn_empresa_externas.empty?
    end

    def no_invstgdrs?
    	self.krn_investigadores.empty?
    end

    def n_dnncs
    	(self.demo? or self.krn_formato == 'B') ? 1 : 20
    end

    def new_bttn?
    	self.krn_denuncias.count < self.n_dnncs
    end

end