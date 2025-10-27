class Cliente < ApplicationRecord

	TIPOS = ['Empresa', 'Sindicato', 'Trabajador']

    has_one :tenant, as: :owner, dependent: :destroy
	has_many :usuarios, through: :tenant
#    after_create :crear_tenant

	# tabla de CLIENTES
	# 1.- Evaluar has_many tar_facturas

	has_many :app_nominas, as: :ownr

	has_many :causas
	has_many :asesorias
	has_many :cargos

	has_many :tar_tarifas, as: :ownr
	has_many :tar_servicios, as: :ownr
	has_many :tar_aprobaciones

	has_many :krn_denuncias, as: :ownr
	has_many :krn_empresa_externas, as: :ownr
	has_many :krn_investigadores, as: :ownr

	has_many :age_actividades, as: :ownr

    has_one :rcrs_logo, as: :ownr
	has_many :app_contactos, as: :ownr
	has_many :app_archivos, as: :ownr
	has_many :notas, as: :ownr

	validates :rut, valida_rut: true
    validates_presence_of :razon_social, :tipo_cliente

    scope :std, ->(estado) { where(estado: estado)}
    scope :typ, ->(tipo) { where(estado: 'activo', tipo_cliente: tipo) }

    scope :cl_ordr, -> { order(preferente: :desc, razon_social: :asc) }


    # Procedimiento Investigación y Sanción

    def logo_url
        self.rcrs_logo.blank? ? 'tyc.png' : self.rcrs_logo.logo.resized.url
    end

    def cntcts_array
        [(verificacion_datos? ? 'RRHH' : nil),
            (coordinacion_apt? ? 'Apt' : nil),
            'Backup'].compact
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

    # CHILDS

	def actividades
		AgeActividad.where(owner_class: self.class.name, owner_id: self.id).order(fecha: :desc)
	end

	def facturas
		TarFactura.where(owner_class: self.class.name, owner_id: self.id)
	end

	# OBJETO

    def st_modelo
    	StModelo.find_by(st_modelo: self.class.name)
    end

	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	# Archivos y control de archivos

	# Nombres de los archivos
	def nms
		self.app_archivos.nms.union(self.documentos.nms)
	end

	def fnd_fl(app_archivo)
		self.app_archivos.find_by(app_archivo: app_archivo)
	end

	def acs
		self.st_modelo.acs
	end

	# Archivos NO Controlados
	def as
		self.app_archivos.where.not(app_archivo: self.acs.nms)
	end

	def dcs
		self.st_modelo.dcs
	end

	# ----------------------------------------------------

	def nombres_usados
		self.archivos.map {|archivo| archivo.app_archivo}
	end

	def archivos
		AppArchivo.where(owner_class: 'Cliente', owner_id: self.id)
	end

	def archivos_controlados
		self.st_modelo.control_documentos.where(tipo: 'Archivo').order(:nombre)
	end

	def archivos_pendientes
		ids = self.archivos_controlados.map {|control| control.id unless self.nombres_usados.include?(control.nombre) }.compact
		ControlDocumento.where(id: ids)
	end

	def archivos_faltantes
		self.archivos_pendientes.where(control: 'Requerido')
	end

	def archivos_vacios
		nombres_controlados = self.archivos_controlados.where(control: 'Requerido').map {|ac| ac.nombre}
		self.archivos.where(app_archivo: nombres_controlados, archivo: nil)
	end
	# ------------------------------------------------------------

	def exclude_files
		self.st_modelo.blank? ? [] : self.st_modelo.control_documentos.where(tipo: 'Archivo').order(:nombre).map {|cd| cd.nombre}
	end

	# Hasta aqui revisado!

	def aprobaciones
		self.facturaciones.where(estado: 'aprobación').order(created_at: :desc)
	end

	def facturaciones_pendientes
		self.facturaciones.where(estado: 'aprobado', tar_factura_id: nil)
	end

	# DEPRECATED
	def aprob_total_uf
		self.aprobaciones.map {|facturacion| facturacion.monto_uf}.sum
	end

	# DEPRECATED
	def aprob_total_pesos
		self.aprobaciones.map {|facturacion| facturacion.monto_pesos}.sum
	end

	def uf_dia
		uf = TarUfSistema.find_by(fecha: Time.zone.today.to_date)
		uf.blank? ? 0 : uf.valor
	end

	def monto_factura_aprobacion_pesos
		self.facturaciones.where(tar_factura_id: nil).map {|fctrcn| fctrcn.moneda == 'Pesos' ? fctrcn.monto : fctrcn.monto * self.uf_dia }.sum
	end

	def monto_factura_aprobacion_uf
		self.facturaciones.where(tar_factura_id: nil).map {|fctrcn| fctrcn.moneda == 'Pesos' ? fctrcn.monto / self.uf_dia : fctrcn.monto }.sum
	end

end
