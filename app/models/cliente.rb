class Cliente < ApplicationRecord

	TIPOS = ['Empresa', 'Sindicato', 'Trabajador']

	# tabla de CLIENTES
	# 1.- Evaluar has_many tar_facturas

	has_many :app_nominas, as: :ownr

	has_many :app_archivos, as: :ownr

	has_many :causas
	has_many :asesorias
	has_many :cargos

	has_many :tar_aprobaciones

	has_many :org_areas
	has_many :org_regiones

#	has_many :var_clis
#	has_many :variables, through: :var_clis

	has_many :pro_dtll_ventas, as: :ownr

	has_many :krn_denuncias, as: :ownr
	has_many :krn_empresa_externas, as: :ownr
	has_many :krn_investigadores, as: :ownr

	has_many :age_actividades, as: :ownr

	has_many :notas, as: :ownr

	validates :rut, valida_rut: true
    validates_presence_of :razon_social, :tipo_cliente

    scope :std, ->(estado) { where(estado: estado)}
    scope :typ, ->(tipo) { where(estado: 'activo', tipo_cliente: tipo) }

    scope :cl_ordr, -> { order(preferente: :desc, razon_social: :asc) }


    def krn?
    	self.pro_dtll_ventas.map {|dv| dv.producto.codigo.split('_')[0]}.include?('krn')
    end

    def krn_formato
    	self.pro_dtll_ventas.map {|dv| dv.producto.formato if dv.producto.present?}.last
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

    # CHILDS

	def tarifas
		TarTarifa.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def actividades
		AgeActividad.where(owner_class: self.class.name, owner_id: self.id).order(fecha: :desc)
	end

	def servicios
		TarServicio.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def facturas
		TarFactura.where(owner_class: self.class.name, owner_id: self.id)
	end

	# OBJETO

    def d_rut
    	self.rut.gsub(' ', '').insert(-8, '.').insert(-5, '.').insert(-2, '-')
    end

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

	def sucursales
		sucursales_ids = []
		self.org_regiones.each do |reg|
			sucursales_ids = sucursales_ids.union(reg.org_sucursales.ids)
		end
		OrgSucursal.where(id: sucursales_ids)
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
