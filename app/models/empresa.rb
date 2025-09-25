class Empresa < ApplicationRecord
    attr_accessor :website  # honeypot
    
    # Logo con Active Storage
    has_one_attached :logo

	has_many :app_nominas, as: :ownr

	has_many :pro_dtll_ventas, as: :ownr

	has_many :krn_investigadores, as: :ownr
	has_many :krn_denuncias, as: :ownr
	has_many :krn_empresa_externas, as: :ownr

    has_one :rcrs_logo, as: :ownr
    has_many :app_contactos, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true
    validates :email_administrador, valida_admin_empresa: true, unless: :persisted?
    validates_uniqueness_of :rut, :email_administrador
    validates_presence_of :razon_social, :email_administrador

    # Valida logo ingresado por Active Storage
    validate :acceptable_logo

    validates :email_administrador, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :telefono, length: { maximum: 25 }, allow_blank: true
    validates :razon_social, length: { maximum: 200 }
    validates :administrador, length: { maximum: 120 }

    include Prdct

    def cnt_cntrllr
    	'emprss'
    end

    def logo_url
        self.rcrs_logo.blank? ? 'logo/logo_60.png' : self.rcrs_logo.logo.resized.url
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

    # PRODUCTOS

    def fecha_demo_activa?
        self.created_at.to_date.in_time_zone > 10.days.ago.in_time_zone
    end


    # DEPRECATED
    def operable?
        externas  = 
        # pendiente manejo de productos: vencimiento y bloqueo
        productos = true
        externas and self.investigadores?
    end

	# OBJETO

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

    # ---------------------------------------------------------------------------------
    private

        def acceptable_logo
            return unless logo.attached?

            unless logo.blob.byte_size <= 2.megabytes
              errors.add(:logo, "debe pesar 2MB o menos")
            end

            acceptable_types = ["image/png", "image/jpeg", "image/webp", "image/svg+xml"]
            unless acceptable_types.include?(logo.content_type)
              errors.add(:logo, "debe ser PNG, JPG, WEBP o SVG")
            end
        end

end