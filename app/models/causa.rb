class Causa < ApplicationRecord
	# Tabla de CAUSAS
	# pertenece a tar_tarifa

	TIPOS=['Juicio', 'Demanda']

	TABLA_FIELDS = 	[
		'created_at',
		'd_id',
		's#causa',
		'cliente:razon_social'
#		'tipo_causa:tipo_causa'
	]

	belongs_to :cliente
	belongs_to :tribunal_corte
	belongs_to :tar_tarifa, optional: true

	belongs_to :tipo_causa

	has_many :antecedentes
	has_many :temas

	has_many :causa_docs
	has_many :app_documentos, through: :causa_docs

    validates_presence_of :causa, :rit

    # OWN CHILDS

    # Valores de la cuantía de la causa
	def valores_cuantia
		TarValorCuantia.where(owner_class: self.class.name, owner_id: self.id)
	end

	# Pagos de la causa
	def facturaciones
		TarFacturacion.where(owner_class: self.class.name, owner_id: self.id)
	end

	# >archivos y control de archivos
	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	def exclude_files
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Archivo').order(:nombre).map {|cd| cd.nombre}
	end

	# Documentos y control de documentos
	def documentos
		AppDocumento.where(owner_class: self.class.name, owner_id: self.id)
	end

	def exclude_docs
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Documento').order(:nombre).map {|cd| cd.nombre}
	end

	# enlaces
	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	# Valores asignados a las variables
	def valores_datos
		Valor.where(owner_class: self.class.name, owner_id: self.id)
	end

	# Actividades
	def actividades
		AgeActividad.where(owner_class: self.class.name, owner_id: self.id).order(fecha: :desc)
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

    def child_records?
    	valores_cuantia.any? or
    	facturaciones.any? or
    	archivos.any? or 
    	documentos.any? or
    	enlaces.any? or
    	valores_datos.any? or
    	actividades.any? or
    	reportes.any? or 
    	registros.any? or
    	uf_facturaciones.any?
    end

    # **************************************************** CÁLCULO DE TARIFA [PAGOS]

	# Encuentra el PAGO (TarFacturacion) asociado al pago
	def pago_generado(pago)
#		self.facturaciones.find_by(facturable: pago.codigo_formula)
		self.facturaciones.find_by(tar_pago_id: pago.id)
	end

	# Encuentra la UF de Cálculo (TarUfFacturacion) asociado al pago
	def tar_uf_facturacion(pago)
		self.uf_facturaciones.find_by(tar_pago_id: pago.id)
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

    # ****************************************************

    def st_modelo
    	StModelo.find_by(st_modelo: self.class.name)
    end

	# Hasta aqui revisado!

	# DEPRECATED
	def valores
		TarValor.where(owner_class: self.class.name, owner_id: self.id)
	end

	def tarifas_cliente
		self.cliente.tarifas
	end

	def facturado_pesos
		self.facturaciones.map {|factn| factn.monto_pesos}.sum
	end

	def facturado_uf
		self.facturaciones.map {|factn| factn.monto_uf}.sum
	end

	def repositorio
    	AppRepositorio.where(owner_class: self.class.name).find_by(owner_id: self.id)
	end

	def demanda?
		self.repositorio.blank? ? false : self.repositorio.archivos.where(app_archivo: 'Demanda').present?
	end

	def demanda
		self.repositorio.archivos.find_by(app_archivo: 'Demanda')
	end

	def total_cuantia
		v_pesos = self.valores_cuantia.map {|vc| vc.valor if vc.moneda == 'Pesos'}.compact
		v_uf = self.valores_cuantia.map {|vc| vc.valor if vc.moneda != 'Pesos'}.compact
		cuantia_pesos = v_pesos.empty? ? 0 : v_pesos.sum
		cuantia_uf = v_uf.empty? ? 0 : v_uf.sum
		[cuantia_pesos, cuantia_uf]
	end

	def cuantia_pesos(pago)
		uf = self.uf_calculo_pago(pago)
		c_uf = self.valores_cuantia.where.not(moneda: 'Pesos')
		(c_uf.any? and uf.blank?) ? 0 : self.valores_cuantia.map { |vc| (vc.moneda == 'Pesos' ? vc.valor : (uf.blank? ? 0 : vc.valor * uf.valor)) }.sum
	end

	def cuantia_uf(pago)
		uf = self.uf_calculo_pago(pago)
		c_pesos = self.valores_cuantia.where(moneda: 'Pesos')
		(c_pesos.any? and uf.blank?) ? 0 : self.valores_cuantia.map { |vc| (vc.moneda == 'Pesos' ? (uf.blank? ? 0 : vc.valor / uf.valor) : vc.valor) }.sum
	end

	def monto_pagado_uf(pago)
		uf = self.uf_calculo_pago(pago)
		(uf.blank? or self.monto_pagado.blank?) ? 0 : self.monto_pagado / uf.valor
	end

	def v_cuantia
		[self.valores_cuantia.map {|vc| vc.valor}.sum, self.valores_cuantia.map {|vc| vc.valor_uf}.sum]
	end

	def as_owner
		self.causa
	end

	def d_id
		self.rit.blank? ? ( self.rol.blank? ? self.identificador : "#{self.rol} : #{self.era}") : self.rit
	end

	def detalle_cuantia(moneda)
		valor = self.valores_cuantia.map { |vc| vc.valor if vc.moneda == moneda }.compact.sum
		valor.blank? ? 0 : valor
	end

end
