class Causa < ApplicationRecord

	include PgSearch

	pg_search_scope :search_for, against: {
		causa: 'A',
		rit: 'B'
	}, using: { tsearch: {prefix: true, any_word: true} }

	CALC_VALORES = [ 
		'#cuantia_pesos', '#cuantia_uf', '#monto_pagado', '#monto_pagado_uf', '#facturado_pesos', '#facturado_uf',
		'$Remuneración'
	]

	belongs_to :cliente
	belongs_to :tribunal_corte
	belongs_to :tar_tarifa, optional: true

	belongs_to :tipo_causa

	has_many :temas
	has_many :hechos
	has_many :demandantes

	has_many :rep_archivos, as: :ownr

	has_many :app_archivos, as: :ownr

	has_many :secciones
	has_many :parrafos
	has_many :estados
	has_many :monto_conciliaciones

	has_many :age_actividades, as: :ownr
	has_many :tar_calculos, as: :ownr
	has_many :tar_facturaciones, as: :ownr
	has_many :tar_uf_facturaciones, as: :ownr
	has_many :tar_valor_cuantias, as: :ownr

	has_many :notas, as: :ownr

	# antecedentes de los hechos de la tabla
	has_many :antecedentes

    validates_presence_of :causa, :rit

    # en MIGRACIÓN
    scope :std, ->(estado) { where(estado: estado).order(:fecha_audiencia) }
    scope :std_pago, ->(estado_pago) { where(estado_pago: estado_pago).order(:fecha_audiencia) }
    # DEPRECATED : Se cambia por std('ingreso'), se deben migrar todas las causas que están en estado 'tramitación'
    scope :no_fctrds, -> {where(id: all.map {|cs| cs.id if cs.tar_calculos.empty?}.compact)}
    scope :trmtcn, -> { where(estado: ['ingreso', 'tramitación']).order(:fecha_audiencia) }

    delegate :tar_pagos, to: :tar_tarifa, prefix: true
	delegate :tipo_causa, to: :tipo_causa, prefix: true

	def demanda
		self.app_archivos.find_by(app_archivo: 'Demanda')
	end

	def demanda?
		self.demanda.present?
	end

    # ---------------------------------------------------------------- ESTADO Y ESTADO PAGO

    def get_estado
    	audncs 		= self.age_actividades.adncs
    	n_audncs 	= audncs.count

    	n_audncs == 0 ? 'ingreso' : (self.archvd ? 'archivada' : 'tramitación')
    end

    def get_estado_pago
    	n_clcls	= self.tar_calculos.count
    	n_pgs 	= self.tar_tarifa.blank? ? 0 : self.tar_tarifa.tar_pagos.count

    	n_clcls == 0 ? 'vacios' : (n_clcls == n_pgs ? 'completos' : (self.monto_pagado? ? 'monto' : 'incompleto'))
    end

    # ---------------------------------------------------------------- ACTIVIDADES

    def audiencia_proxima
    	audiencias = self.age_actividades.adncs.ftrs.fecha_ordr
    	audiencias.empty? ? nil : audiencias.first
    end

    def get_age_actividad(nombre)
    	self.age_actividades.find_by(age_actividad: nombre)
    end

    # ---------------------------------------------------------------- MGRTN

	# PAGOS

	# Número de cálculos de tarifa realizados
	def clcls
		self.tar_calculos.count
	end

	# Número de pagos en la tarifa
	def pgs_trf
		self.tar_tarifa.blank? ? 0 : self.tar_tarifa.tar_pagos.count
	end

	# Archivos y control de archivos

	# Nombres de los archivos
	def nms
		self.app_archivos.nms.union(self.documentos.nms)
	end

	def fnd_fl(app_archivo)
		self.app_archivos.find_by(app_archivo: app_archivo)
	end

	# Archivos controlados
	def acs
		self.tipo_causa.acs
	end

	# Archivos NO Controlados
	def as
		self.app_archivos.where.not(app_archivo: self.acs.nms)
	end

	def dcs
		self.tipo_causa.dcs
	end

	# -------------------------------------------------------------------------------------------------------

	def nombres_usados
		self.archivos.map {|archivo| archivo.app_archivo}
	end

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	def archivos_controlados
		self.tipo_causa.control_documentos.where(tipo: 'Archivo').order(:nombre)
	end

	def archivos_pendientes
		ids = self.archivos_controlados.map {|control| control.id unless self.nombres_usados.include?(control.nombre) }.compact
		ControlDocumento.where(id: ids)
	end

	# ------------------------------------------------------------

	def exclude_files
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Archivo').order(:nombre).map {|cd| cd.nombre}
	end

	def reportes
		RegReporte.where(owner_class: self.class.name, owner_id: self.id)
	end

	def registros
    	Registro.where(owner_class: self.class.name, owner_id: self.id)
	end

	def uf_facturaciones
		TarUfFacturacion.where(owner_class: self.class.name, owner_id: self.id)
	end

    # **************************************************** CÁLCULO DE TARIFA [PAGOS]

	# Encuentra el PAGO (TarFacturacion) asociado al pago
	def pago_generado(objeto)
		# objeto.class.name {TarPago, TarCuota}
		objeto.class.name == 'TarPago' ? self.tar_facturaciones.find_by(tar_pago_id: objeto.id) : self.tar_facturaciones.find_by(tar_cuota_id: objeto.id)
	end

	# REVISAR --> DEPRECATED : Se remplaza por uf_tacturacion en concerns::tarifas
	# Encuentra la UF de Cálculo (TarUfFacturacion) asociado al pago
	def tar_uf_facturacion(pago)
		self.tar_uf_facturaciones.find_by(tar_pago_id: pago.id)
	end

	def origen_fecha_pago(pago)
		if self.tar_uf_facturacion(pago).present?
			'TarUfFacturacion'
		elsif self.pago_generado(pago).present?
			'TarPago'
		else
			'Today'
		end
	end

	# REVISAR --> DEPRECATED, se agregó fecha_uf a TarFacturacion, en ella se almacenará la fecha de cálculo
	# Ya sea que esta provenga de TarUfFacturacion o sea la fecha de la creación de TarFacturacion
	def fecha_calculo_pago(pago)
		if self.tar_uf_facturacion(pago).present?
			self.tar_uf_facturacion(pago).fecha_uf
		elsif self.pago_generado(pago).present?
			self.pago_generado(pago).created_at
		else
			Time.zone.today.to_date
		end
	end

	def uf_calculo_pago(pago)
		TarUfSistema.find_by(fecha: fecha_calculo_pago(pago))
	end

	def facturado_pesos
		self.tar_facturaciones.map {|factn| factn.monto_pesos}.sum
	end

	def facturado_uf
		self.tar_facturaciones.map {|factn| factn.monto_uf}.sum
	end

    # ****************************************************

    # Revisar uso
    def st_modelo
    	StModelo.find_by(st_modelo: self.class.name)
    end

	def tarifas_cliente
		self.cliente.tar_tarifas
	end

	def monto_pagado_pesos(pago)
		self.monto_pagado
	end

	def monto_pagado_uf(pago)
		uf = self.uf_calculo_pago(pago)
		(uf.blank? or self.monto_pagado.blank?) ? 0 : self.monto_pagado / uf.valor
	end

	# /legal/app/views/causas/list/_monto_pagado.html.erb:
	def detalle_cuantia(moneda)
		valor = self.tar_valor_cuantias.map { |vc| vc.valor if vc.moneda == moneda }.compact.sum
		valor.blank? ? 0 : valor
	end

end
