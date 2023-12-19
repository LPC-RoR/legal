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

	def valores_cuantia
		TarValorCuantia.where(owner_class: self.class.name, owner_id: self.id)
	end

	def facturaciones
		TarFacturacion.where(owner_class: self.class.name, owner_id: self.id)
	end

    def st_modelo
    	StModelo.find_by(st_modelo: self.class.name)
    end

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	def exclude_files
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Archivo').order(:nombre).map {|cd| cd.nombre}
	end

	def documentos
		AppDocumento.where(owner_class: self.class.name, owner_id: self.id)
	end

	def exclude_docs
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Documento').order(:nombre).map {|cd| cd.nombre}
	end

	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	def valores_datos
		Valor.where(owner_class: self.class.name, owner_id: self.id)
	end

	def actividades
		AgeActividad.where(owner_class: self.class.name, owner_id: self.id).order(fecha: :desc)
	end

	# Hasta aqui revisado!

	def valores
		TarValor.where(owner_class: self.class.name, owner_id: self.id)
	end

	def tarifas_cliente
		self.cliente.tarifas
	end

	def tarifas_hora_cliente
		self.cliente.tarifas_hora
	end

	# Encuentra el PAGO (TarFacturacion) asociado al pago
	def pago_generado(pago)
		self.facturaciones.find_by(facturable: pago.codigo_formula)
	end

	# Encuentra la UF de Cálculo (TarUfFacturacion) asociado al pago
	def tar_uf_facturacion(pago)
		self.uf_facturaciones.find_by(pago: pago.tar_pago)
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

	def reportes
		reportes_clase = RegReporte.where(owner_class: self.class.name)
		reportes_clase.blank? ? nil : reportes_clase.where(owner_id: self.id)
	end

	def registros
    	Registro.where(owner_class: self.class.name, owner_id: self.id)
	end

	def fecha_calculo
#		self.fecha_uf.blank? ? DateTime.now.to_date : self.fecha_uf.to_date
		self.fecha_uf.blank? ? Time.zone.today : self.fecha_uf.to_date
	end

	def uf_calculo
		uf = TarUfSistema.find_by(fecha: self.fecha_calculo)
		uf.blank? ? nil : uf.valor
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

	def d_cuantia
#		"#{self.valores_cuantia.where(moneda: 'Pesos').map {|val| val.valor}.sum} #{self.valores_cuantia.where(moneda: 'UF').map {|val| val.valor}.sum}"
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

	def uf_facturaciones
		TarUfFacturacion.where(owner_class: self.class.name, owner_id: self.id)
	end

	def fecha_uf_pago(nombre_pago)
		uf_facturacion = self.uf_facturaciones.find_by(pago: nombre_pago)
		uf_facturacion.blank? ? Time.zone.today : uf_facturacion.fecha_uf
	end

	def uf_pago(nombre_pago)
		TarUfSistema.find_by(fecha: self.fecha_uf_pago(nombre_pago).to_date)
	end

	def detalle_cuantia(moneda)
		valor = self.valores_cuantia.map { |vc| vc.valor if vc.moneda == moneda }.compact.sum
		valor.blank? ? 0 : valor
	end

end
