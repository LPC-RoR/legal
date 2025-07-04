class Empresa < ApplicationRecord
    
	has_many :app_nominas, as: :ownr

	has_many :pro_dtll_ventas, as: :ownr

	has_many :krn_investigadores, as: :ownr
	has_many :krn_denuncias, as: :ownr
	has_many :krn_empresa_externas, as: :ownr

    has_one :rcrs_logo, as: :ownr
    has_many :app_contactos, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true
    validates :email_administrador, valida_admin_empresa: true
    validates_uniqueness_of :rut, :email_administrador
    validates_presence_of :razon_social, :email_administrador

    def cnt_cntrllr
    	'emprss'
    end

    def logo_url
        self.rcrs_logo.blank? ? 'krn_nvbr.png' : self.rcrs_logo.logo.resized.url
    end

    # Procedimiento Investigación y Snación

    def productos?
        self.pro_dtll_ventas.any?
    end

    def nomina?
        self.app_nominas.any?
    end

    def investigadores?
        self.krn_investigadores.any?
    end

    def empresas_externas?
        self.krn_empresa_externas.any?
    end

	# OBJETO

    def operable?
        externas  = self.principal_usuaria ? self.empresas_externas? : true
        # pendiente manejo de productos: vencimiento y bloqueo
        productos = true
        externas and self.investigadores?
    end

    def formatos
        self.productos? ? self.pro_dtll_ventas.map {|pro| pro.formato} : []
    end

    def n_dnncs
        # Si tiene productos puede ser 1 (B) o 20, si no (DEMO) son 10
    	self.productos? ? (self.formatos.include?('B') ? 1 : 10) : 10
    end

    def new_bttn?
    	self.krn_denuncias.count < self.n_dnncs
    end

    def demo_activo?
        self.productos? ? true : (self.created_at.to_date.in_time_zone > 10.days.ago.in_time_zone)
    end

    # ---------------------------------------------------------------------------------

end