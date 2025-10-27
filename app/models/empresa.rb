class Empresa < ApplicationRecord
    attr_accessor :website  # honeypot

    has_one :tenant, as: :owner, dependent: :destroy
    has_many :usuarios, through: :tenant
#    after_create :crear_tenant

    # Logo con Active Storage
    has_one_attached :logo

	has_many :app_nominas, as: :ownr

    has_many :licencias, dependent: :destroy

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

    # crea la demo la primera vez que se registra
    after_create :crear_demo!

    def cnt_cntrllr
    	'emprss'
    end

    def logo_url
        self.rcrs_logo.blank? ? 'logo/logo_60.png' : self.rcrs_logo.logo.resized.url
    end

    # Configuración reportes

    def cntcts_array
        [(verificacion_datos? ? 'RRHH' : nil),
            (coordinacion_apt? ? 'Apt' : nil),
            'Backup'].compact
    end

    # KrnDenuncia
    def destinatarios(rprt)
      # bloque re-utilizable
      build_hash = ->(obj) { { objt: obj, email: ( demo? ? email_administrador : obj.email ), nombre: obj.nombre } }

      [].tap do |list|
        # 1) app_contactos
        app_contactos.find_each do |contacto|
            if (rprt == 'crdncn_apt' and contacto.grupo == 'Apt') or (rprt == 'infrmcn' and contacto.grupo == 'RRHH')
                list << build_hash.call(contacto)
            end
        end

      end
    end

    # Licencias

    # la licencia “vigente” es la última activa
    def licencia_actual
        licencias.active.order(:created_at).last
    end

    def licencia_activa?
        actual = licencia_actual
        actual.present? and (not actual.expirada?) and (not actual.tope_alcanzado?)
    end

    # Procedimiento Investigación y Sanción

    def cnfgrcn_ok?
        krn_investigadores.any? and 
        app_nominas.any? and 
        (plan_type == 'extendido' ? krn_empresa_externas.any? : true ) and
        (verificacion_datos ? app_contactos.where(grupo: 'RRHH').any? : true) and 
        (coordinacion_apt ? app_contactos.where(grupo: 'Apt').any? : true ) and
        app_contactos.where(grupo: 'Backup').any?
    end

    def demo?
        licencia_actual? and licencia_actual.plan == 'demo'
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

    # ---------------------------------------------------------------------------------
    private

    def crear_tenant
        Tenant.create!(nombre: razon_social, owner: self)
    end

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

    def crear_demo!
        licencias.create!(
            plan:            'demo',
            status:          'active',
            max_denuncias:   5,
            started_at:      Time.current,
            finished_at:     10.days.from_now
        )
    end

end